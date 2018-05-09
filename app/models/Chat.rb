# Base Chat Class
# Note:	Originally p_id meant participantID and it allowed us to get the chatId
# 			just from knowing the participants. This also allowed us to ensure that
#				each 1-1 chat was only created a single time
#				
#				With group chats, we want more flexibility in participants so pId = chatId
class Chat
	attr_accessor :participants, :chat_id, :p_id, :name, :group, :meta, :admins
	def initialize(participantsOrId, group = false, name = "")
		@creating = false
		@ready = false
		@msgs = []
		@onReadies = []
		@participants = []
		@admins = []
		@meta = {}
		@watchRef = false
		@name = name
		@group = group
		@p_id = false
		@last_read = 0
		if participantsOrId.kind_of?(Array)
			participantsOrId.each do |p|
				addParticipant(p, false)
			end
		else
			@p_id = participantsOrId
		end
		createIfNotExists
	end
	def isExisting(&block)
		if @group
			@chat_id = @p_id
			block.call(@p_id)
		else
			Fire.get "/chat_participants/#{@p_id}" do |rsp|
				if !rsp.value.nil? and rsp.value.length > 0
					@chat_id = rsp.value
					block.call(true)
				else
					block.call(false)
				end
			end
		end
	end
	def createIfNotExists
		isExisting do |exists|
			unless exists
				create
			end
			initLastRead
			getMeta do
				@ready = true
				@onReadies.each do |onReady|
					onReady.call
				end
			end
		end
	end
	def create
		unless @creating
			@creating = true
			@chat_id = Fire.createAt('/chats')
			if @group
				@p_id = @chat_id
				set('name', @name)
				set('creator', Me.atn.user_id)
				set('admins', [Me.atn.user_id])
			else
				Fire.set("/chat_participants/#{@p_id}", @chat_id)
				set('pid', @p_id)
			end
			set('last_msg', {})
			if (@p_id.include?('support'))
				addParticipant(Me.atn)
				addParticipant('support')
			end
			set('participants', @participants)
			@participants.each do |p|
				Fire.set('/chats_by_user/'+p[:user_id].to_s+'/'+@chat_id, '1')
			end
		end
	end
	def whenReady(&block)
		if @ready
			block.call
		else
			@onReadies << block
		end
	end
	def initLastRead
		Fire.get '/chats_by_user/'+Me.atn.user_id.to_s+'/'+@chat_id do |rsp|
			@last_read = rsp.value
		end
	end
	def set(key, val)
		Fire.set("/chats/#{@chat_id}/#{key}", val)
	end
	def send(msg)
		msg = msg.strip
		from = Me.atn.user_id
		msg_id = Fire.createAt("/chat_messages/#{@chat_id}")
		@last_read = FIRServerValue.timestamp
		msgObj = {
			msg: msg,
			user_id: from,
			created_at: @last_read
		}
		Fire.set("/chat_messages/#{@chat_id}/#{msg_id}", msgObj)
		Fire.set('/chats_by_user/'+Me.atn.user_id.to_s+'/'+@chat_id, @last_read)
		summary = msg
		summary = summary[0..100]+'...' if summary.length > 100
		to = []
		@meta[:participants].each do |p|
			to << p[:user_id].to_s if p[:user_id].to_s != from.to_s
		end
		if @p_id.include?('support')
			params = {
				url: 'https://concierge.wds.fm/',
				message: msg,
				user: {
					first_name: Me.atn.first_name,
					last_name: Me.atn.last_name,
					user_id: Me.atn.user_id
				}
			}
			Api.post 'message/toSlack', params do |rsp|
			end
		else
			params = {
				chat_id: @p_id,
				chat_name: @name,
				user_id: to,
				summary: summary
			}
			Api.post 'message', params do |rsp|
			end
		end
		set 'last_msg', msgObj
	end
	def addParticipantId(ids)
		ids.sort!
		@p_id = ids.join('_')
	end
	def addParticipant(atn, update = true)
		if atn == 'support'
			p = {
				user_id: 'support',
				first_name: 'WDS',
				last_name: 'Team'
			}
		else
			p = {
				first_name: atn.first_name,
				last_name: atn.last_name,
				user_id: atn.user_id
			}
		end
		@participants << p
		if @participants.length > 0
			@participants.sort! {|x, y| x[:user_id].to_s <=> y[:user_id].to_s }
		end
		ids = []
		@participants.each do |participant|
			ids << participant[:user_id]
		end
		unless @group
			@p_id = ids.join('_')
		end
		if update
			addParticipantToFire(atn)
			set('participants', @participants)
		end
	end
	def addParticipantToFire(atn)
		if atn.respond_to?('user_id')
			Fire.set('/chats_by_user/'+atn.user_id.to_s+'/'+@chat_id, '1')
		end
	end
	def removeParticipant(atn)
		Fire.remove('/chats_by_user/'+atn["user_id"].to_s+'/'+@chat_id)
		@participants = @participants.select do |p| p["user_id"] != atn["user_id"] end
		set('participants', @participants)
	end
	def addAdmin(user_id)
		@admins ||= []
		@admins << user_id
		set('admins', @admins)
	end
	def removeAdmin(user_id)
		@admins ||= []
		@admins = @admins.select do |p| p != user_id end
		set('admins', @admins)
	end
	def getMeta(&block)
		Fire.get "/chats/#{@chat_id}" do |rsp|
			@meta = rsp.value
			@admins = @meta[:admins]
			@participants = @meta[:participants]
			block.call
		end
	end
	def watch(&block)
		if !@chat_id.nil? and @chat_id.length > 0 and !@watchRef
			query = [{type: 'orderChild', val: 'created_at'}, {type: 'limitLast', val: 15}]
			cached = Store.get("chat-#{@chat_id}", true)
			if cached
				block.call(cached) if cached
			end
			Fire.query "value-single", "/chat_messages/#{@chat_id}", query  do |rsp|
				unless rsp.value.nil?
					rsp.children.each do |child|
						addMsg(child.value)
					end
				end
				block.call(@msgs)
			end
			@loadAllTimo = 3.seconds.later do
				query = [{type: 'orderChild', val: 'created_at'}, {type: 'limitLast', val: 500}]
				Fire.query "value-single", "/chat_messages/#{@chat_id}/", query  do |rsp|
					unless rsp.value.nil?
						@msgs = []
						rsp.children.each do |child|
							addMsg(child.value)
						end
					end
					save
					block.call(@msgs)
				end
			end
		end
		now = (NSDate.new.timeIntervalSince1970 * 1000)+200
		query = [{type: 'orderChild', val: 'created_at'}, {type: 'startChildAt', val: now, child: 'created_at'}]
		@watchRef = Fire.query "added", "/chat_messages/#{@chat_id}", query  do |rsp|
			unless rsp.value.nil?
				addMsg(rsp.value)
			end
			save
			block.call(@msgs)
		end
	end
	def save
		if @chat_id
			Store.set("chat-#{$chat_id}", @msgs, true)
		end
	end
	def addMsg(msg)
		last = 0
		@meta[:participants].each do |p|
			if p[:user_id].to_s == msg[:user_id].to_s
				msg[:author] = ''
				unless p[:first_name].nil?
					msg[:author] += p[:first_name]
				end
				unless p[:last_name].nil?
					msg[:author]+= ' '+p[:last_name][0]+'.'
				end
			end
		end
		unless msg[:name].nil?
			msg[:author] = msg[:name]
		end
		last_msg = @msgs[last]
		if last_msg.nil?
			@msgs.unshift(msg)
		else
			diff = (msg[:created_at].to_i - last_msg[:created_at].to_i)/1000
			if (last_msg[:user_id] == msg[:user_id]) and diff < 120
				@msgs[last][:created_at] = msg[:created_at]
				@msgs[last][:msg] += "\n\n"+msg[:msg]
			else
				@msgs.unshift(msg)
			end
		end
		if @last_read.to_s < msg[:created_at].to_s
			@last_read = FIRServerValue.timestamp
			Fire.set('/chats_by_user/'+Me.atn.user_id.to_s+'/'+@chat_id, @last_read)
		end
	end
	def setTyping(isTyping)
		if isTyping
			Fire.set("/chats/#{@chat_id}/typing/#{Me.atn.user_id}", NSDate.new.timeIntervalSince1970)
		else
			Fire.remove("/chats/#{@chat_id}/typing/#{Me.atn.user_id}")
		end
	end
	def watchTyping(&block)
		@typingRef = Fire.watch "value", "/chats/#{@chat_id}/typing" do |rsp|
			writing = ""
			unless rsp.value.nil?
				count = 0
				typing = rsp.value
				now = NSDate.new.timeIntervalSince1970
				typing.each do |user_id, val|
					diff = now - val.to_i
					user_id = user_id.to_s
					if user_id.to_i != Me.atn.user_id.to_i and diff < 10
						p = getParticipant(user_id)
						if count == 1
							writing += ' & '
						end
						writing += p[:first_name] #+' '+p[:last_name][0]+'.'
						count += 1
					end
				end
				if count == 1
					writing += " is typing..."
				elsif count == 2
					writing += " are typing..."
				elsif count > 2
					writing = count.to_s+" WDSers are typing..."
				end
			end
			block.call(writing)
		end
	end
	def unwatch
		unless @loadAllTimo.nil?
			@loadAllTimo.invalidate
		end
		unless @typingRef.nil?
			Fire.unwatch(@typingRef)
		end
		unless @watchRef.nil?
			Fire.unwatch(@watchRef)
		end
	end
	def getParticipant(user_id)
		@participants.each do |p|
			if p[:user_id].to_s == user_id.to_s
				return p
			end
		end
	end
	# def updateParticipants
	# 	Fire.get()
	# end
end