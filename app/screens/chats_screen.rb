class ChatsScreen < PM::Screen
  status_bar :light
  attr_accessor :layout
  title 'Chats'
  status_bar :light
  def on_init
    @last_reads = {}
    @chats = []
    @removing = []
    selected = UIImage.imageNamed('chat_icon_selected').imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed('chat_icon').imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_nav_bar_button :right, title: 'New', action: :new_chat_action
    set_nav_bar_button :left, title: 'Get Help', action: :support_action
    set_tab_bar_item(item: {
                       selected: selected,
                       unselected: unselected
                     },
                     title: '')
  end

  def on_load
    @chat_watches = {}
    @chat_edit_screen = ChatEditScreen.new(nav_bar: true)
    @chat_edit_screen.setParent self
    @chat_screen = ChatScreen.new(nav_bar: true)
    @chat_screen.viewContext = "navview"
    @chat_screen.setParent self
    @layout = ChatsLayout.new(root: view)
    @layout.setController self
    @table = ChatsListing.new
    @table.layout = @layout
    @table.controller = self
    @layout.table = @table.view
    @layout.build
    setState 'loading'
    query = [{ type: 'orderKey' }]
    @keys = []
    @chats = Store.get('chatlist', true) || []
    updateChatList
      Fire.query 'value-single', "/chats_by_user/#{Me.atn.user_id}", query do |rsp|
        unless rsp.value.nil?
          if rsp.childrenCount < 1
            setState 'null'
          else
            rsp.children.each do |child|
              watchChat(child.key, child.value)
            end
            0.2.seconds.later do
              setState 'loaded'
            end
            Fire.watch 'added', "/chats_by_user/#{Me.atn.user_id}" do |rsp|
              unless rsp.value.nil?
                watchChat(rsp.key, rsp.value) unless @keys.include?(rsp.key)
              end
            end
            Fire.watch 'removed', "/chats_by_user/#{Me.atn.user_id}" do |rsp|
              unless rsp.value.nil?
                unwatchChat(rsp.key)
              end
            end
          end
        end
    end
    syncState
    refreshCells
    set_nav_bar_button :right, title: 'New', action: :new_chat_action
    true
  end

  def new_chat_action
    open @chat_edit_screen
  end

  def refreshCells
    table = @layout.get(:chats_list)
    table.visibleCells.each(&:setNeedsDisplay)
    17.seconds.later do
      refreshCells
    end
  end


  def watchChat(chat_id, last_read)
    @keys << chat_id
    @last_reads[chat_id] = last_read
    uRef = Fire.watch 'value', "/chats_by_user/#{Me.atn.user_id}/#{chat_id}" do |user_chat|
      @last_reads[chat_id] = user_chat.value.to_s
      updateChatDebounced
    end
    cRef = Fire.watch 'value', "/chats/#{chat_id}" do |chat|
      unless @removing.include?(chat_id)
        updateChat(chat.key, chat.value) unless chat.value.nil?
      end
    end
    @chat_watches[chat_id] = [uRef, cRef]
  end

  def unwatchChat(chat_id)
    @removing << chat_id
    Fire.unwatch(@chat_watches[chat_id][0])
    Fire.unwatch(@chat_watches[chat_id][1])
    filtered = Store.get('chatlist', []).select do |c| c[:id] != chat_id end
    Store.set('chatlist', filtered, true)
    @chats = @chats.select do |c| c[:id] != chat_id end
    1.5.seconds.later do
     @removing = @removing.select do |c| c != chat_id end
    end
    updateChatDebounced
  end

  def updateChat(key, chat)
    with = []
    av_id = false
    if !chat.nil? && !chat[:participants].nil? && !chat[:last_msg].nil?
      chat[:participants].each do |p|
        if chat[:last_msg].nil?
          pre = ''
        else
          if p[:user_id].to_s == chat[:last_msg][:user_id].to_s
            pre = p[:first_name] + ': '
          end
        end
        if p[:user_id].to_s != Me.atn.user_id.to_s
          with << p[:first_name] + ' ' + p[:last_name]
          av_id = p[:user_id] unless av_id
        end
      end
      with = chat[:name].nil? ? with.join(', ') : chat[:name]
      with = with.length > 65 ? "#{with[0...65]}..." : with
      if !chat[:last_msg].nil?
        if chat[:last_msg][:user_id].to_s == Me.atn.user_id.to_s
          pre = 'You: '
        else
          av_id = chat[:last_msg][:user_id]
        end
        last_msg = pre + chat[:last_msg][:msg]
        last_msg = last_msg.length > 95 ? "#{last_msg[0...95]}..." : last_msg
        last_stamp = chat[:last_msg][:created_at]
      else
        last_msg = 'Get your chat started!'
        last_stamp = 0
      end
      chatData = {
        id: key,
        pid: chat[:name].nil? ? chat[:pid] : key,
        last_msg: last_msg,
        last_msg_stamp: last_stamp,
        with: with,
        av_id: av_id
      }
      unless chat[:name].nil?
        chatData[:name] = chat[:name]
      end
      if @chats && !@chats.empty?
        for inx in 0..(@chats.length - 1)
          found = inx if @chats[inx][:id] == key
        end
        if found.nil?
          @chats << chatData
        else
          @chats[found] = chatData
        end
      else
        @chats << chatData
      end
      saveChatsDebounced
      updateChatDebounced
    end
  end


  def setState(state)
    @state = state
    syncState
  end

  def syncState
    case @state
    when 'loading'
      showLoadingMsg
    when 'null'
      showNullMsg
    when 'loaded'
      showChats
    end
  end

  def showLoadingMsg
    unless @layout.nil?
      @layout.get(:header_name).text = 'Loading...'
      @layout.get(:loading_msg).setHidden false
      @layout.get(:null_msg).setHidden true
      @layout.get(:chats_list).setHidden true
    end
  end

  def showNullMsg
    unless @layout.nil?
      @layout.get(:null_msg).setHidden false
      @layout.get(:chats_list).setHidden true
      @layout.get(:loading_msg).setHidden true
    end
  end

  def showChats
    unless @layout.nil?
      @layout.get(:null_msg).setHidden true
      @layout.get(:chats_list).setHidden false
      @layout.get(:loading_msg).setHidden true
    end
  end

  def openMore(chat)
    @chat_edit_screen.setChat chat
    open @chat_edit_screen
  end

  def open_chat_action(chat)
    @chat_screen.setChatFromPid(chat)
    open @chat_screen
    @chat_screen.clear
  end

  def support_action
    @chat_screen.setChatFromPid({ pid: "#{Me.atn.user_id}_support"})
    open @chat_screen
    @chat_screen.clear
  end

  def open_chat(atns, group = false, name = false)
    @chat_screen.setChat(atns, group, name)
    open @chat_screen
    @chat_screen.clear
  end

  def open_group_chat(atns, name)
    @chat_screen.setChat(atns, true, name)
    open @chat_screen
    @chat_screen.clear
  end

  def saveChatsDebounced
    unless @saveTimo.nil?
      @saveTimo.invalidate
    end
    @saveTimo = 0.5.seconds.later do
      Store.set('chatlist', @chats, true)
    end
  end
  def updateChatDebounced
    unless @updateTimo.nil?
      @updateTimo.invalidate
    end
    @updateTimo = 0.5.seconds.later do
      updateChatList
    end
  end
  def updateChatList
    if @chats
      # puts @chats.inspect
      @chats.sort! { 
        |x, y| 
          # puts '>>'
          # puts x.inspect
          # puts y.inspect
          # puts '<<'
          -x[:last_msg_stamp] <=> -y[:last_msg_stamp] 
      }
      processReads
      @table.update(@chats)
      setState 'loaded'
    end
  end

  def processReads
    unless @chats.empty?
      for inx in 0..(@chats.length - 1)
        chat = @chats[inx]
        last_stamp = chat[:last_msg_stamp]
        last_read = (@last_reads[chat[:id]].to_i + 500)
        chat[:read] = (last_read.to_s >= last_stamp.to_s)
        @chats[inx] = chat
      end
    end
  end

  def shouldAutorotate
    false
  end
end
