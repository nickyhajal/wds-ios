class ChatScreen < PM::Screen
  title "Chat"
  status_bar :light
  attr_accessor :layout, :chat, :msgs, :viewContext
  def on_init
    @needsAtn = false
    @needsAtns = false
    @needsStart = false
    # set_nav_bar_button :right, {
    #   title: "Details",
    #   image: Ion.imageByFont(:ios_more, color:Color.white),
    #   action: :more
    # }
    set_nav_bar_button :right, title: "Host", action: 'open_host'
    # set_nav_bar_button :right, {
    #   image:  Ion.imageByFont(:ios_arrow_forward, color: Color.white, size:26),
    #   action: :openMore
    # }
  end
  def setParent(parent)
    @parent = parent
  end
  def on_load
    @chat_edit_screen = ChatEditScreen.new(nav_bar: true)
    @chat_edit_screen.setParent(self)
    @chat_detail_screen = ChatDetailScreen.new(nav_bar: true)
    @chat_detail_screen.setParent(self)
    @layout = ChatLayout.new(root: self.view)
    @layout.viewContext = @viewContext
    @layout.setController self
    @chat_table = ChatListing.new
    @chat_table.layout = @layout
    @chat_table.controller = self
    @layout.chat_view = @chat_table.view
    @layout.build
    UIKeyboardWillShowNotification.add_observer(self, 'keyboardWillShow:')
    UIKeyboardWillHideNotification.add_observer(self, 'keyboardWillHide:')
    syncState

    # We call setChat before the view has loaded so we can't init the
    # chat in the layout at that time. If that happens, we set some variables
    # and reinit the chat now that the screen is loaded
    if @needsAtn
      setChat(@needsAtn, @group, @name)
      @needsAtn = false
    end
    if @needsAtns
      @layout.setAttendees(atns)
      @layout.reapply!
    end
    if @needsStart
      startChat
    end
    true
  end
  def doNothing
  end
  def openMore
    if @chat.admins.include?(Me.atn.user_id)
      @chat_edit_screen.setChat @chat
      open @chat_edit_screen
    else
      @chat_detail_screen.setChat @chat
      open @chat_detail_screen
    end
  end
  def will_appear
    puts @group
    if !@group.nil? and @group
      set_nav_bar_button :right, title: '•••', action: :openMore
      # set_nav_bar_button :right, {
      #   image:  Ion.imageByFont(:ios_arrow_forward, color: Color.white, size:26),
      #   action: :openMore
      # }
    else
      set_nav_bar_button :right, {
        title: '',
        action: :doNothing
      }
    end
  end
  def on_appear
    if (!@layout.nil? &&  @layout.get(:msg_inp).text.length > 0)
      @layout.updateMsgBoxSize(@layout.get(:msg_inp))
    end
  end
  def back
    close
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
      showChat
    end
  end
  def setChatFromPid(chat)
    setState 'loading'
    @msgs = []
    if @chat.nil? || !@chat
      if chat[:name].nil? || !chat[:name]
        @group = false
        @chat = Chat.new(chat[:pid])
        @chat.whenReady do
          startChat
        end
      else
        setChat(chat[:pid], true, chat[:name])
      end
    end
  end

  # Step 1: Set the chat to display
  def setChat(atn, group = false, name = "")
    setState 'loading'
    @msgs = []
    @group = group
    @name = name
    clear
    if @chat.nil? || !@chat
      with =  [atn, Me.atn]
      if group
        if atn.is_a? String
          with = atn
        else
          with = atn.push(Me.atn)
        end
      end
      @chat = Chat.new(with, group, name)
    end
    if @layout.nil?
      @needsAtn = atn
    else
      if group
        @layout.setChat(@chat)
      else
        @layout.setAttendee(atn)
      end
      startChat
    end
  end
  def startChat
    @chat.whenReady do
      setState 'null'
      @chat.inspect
      @chat.watch do |msg|
        setState 'loaded'
        update(msg)
      end
      @chat.watchTyping do |writing|
        unless @layout.nil?
          @layout.setTyping(writing)
        end
      end
      setAttendees
    end
  end

  def setAttendees
    atns = []
    @chat.participants.each do |p|
      if p[:user_id].to_s != Me.atn.user_id.to_s
        atns << Attendee.new(p)
      end
    end

    if @layout.nil?
      @needsAtns
    else
      unless @group
        @layout.setAttendees(atns)
        @layout.reapply!
      end
    end
  end

  def update(msgs)
    if msgs.length > 0
      @chat_table.update(msgs)
      setState 'loaded'
    else
      setState 'null'
    end
  end
  def post_msg_action
    @chat.setTyping(false)
    msg = @layout.get(:msg_inp).text
    if msg.length > 0
      @layout.get(:msg_inp).text = ''
      @layout.updateMsgBoxSize(@layout.get(:msg_inp))
      @layout.updatePostButton
      @layout.updatePlaceholder
      # @layout.get(:msg_inp).resignFirstResponder
      @chat.send msg
    end
  end
  def showLoadingMsg
    unless @layout.nil?
      @layout.get(:header_name).text = "Loading..."

      ## This way, loading doesn't blink on the screen if it
      ## loads within a few ms
      0.5.seconds.later do
        if @state == 'loading'
          @layout.get(:loading_msg).setHidden false
        end
      end
      @layout.get(:null_msg).setHidden true
      @layout.get(:chat_list).setHidden true
    end
  end
  def showNullMsg
    unless @layout.nil?
      @layout.get(:null_msg).setHidden false
      @layout.get(:chat_list).setHidden true
      @layout.get(:loading_msg).setHidden true
    end
  end
  def showChat
    unless @layout.nil?
      @layout.get(:null_msg).setHidden true
      0.17.seconds.later do
        @layout.get(:chat_list).setHidden false
      end
      @layout.get(:loading_msg).setHidden true
    end
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def clear
    unless @chat_table.nil?
      @chat_table.update([])
    end
  end
  def on_dismiss
    # clear
    # 0.2.seconds.later do
    #   clear
    # end
    close_action(false)
  end
  def close_action(close)
    @layout.get(:msg_inp).resignFirstResponder
    if @chat
      @chat.unwatch
      @chat = false
      clear
      0.2.seconds.later do
        clear
      end
    end
    @layout.chat = false
    @msgs = []
    setState 'loading'
    if close
      close_screen
    end
  end
  def shouldAutorotate
    false
  end
end