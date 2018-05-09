class Notification
	attr_accessor :notification_id, :user_id, :from, :text, :type, :content, :channel_type, :channel_id, :link, :clicked, :read, :created_at, :updated_at, :title
	def initialize(notn)
		notn.each do |key, value|
			unless value.nil?
				self.instance_variable_set("@#{key}".to_sym, value)
			end
		end
	end
	def open(controller, &block)
		if @json.nil?
			@json = BW::JSON.parse(@content)
		end
		if @link[0] == '~'
			controller.open_profile @json[:from_id]
		elsif @link.include? 'dispatch'
			id = link.split('/').last
			controller.open_dispatch id, is_id: true
		elsif @link.include? 'message'
			id = link.split('/').last
			controller.open_chat id, @title
		end
		notifications = []
		notifications << {
			'notification_id' => @notification_id,
			'clicked' => '1'
		}
		Api.post "user/notifications", {notifications: notifications} do |rsp|
			unless block.nil?
				block.call
			end
		end
	end
end
