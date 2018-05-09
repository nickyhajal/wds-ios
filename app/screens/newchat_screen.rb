class NewChatScreen < PM::Screen
  title "Chat"
  status_bar :light
  attr_accessor :layout, :chat, :msgs
  def on_init
    @needsAtn = false
    @needsAtns = false
    set_nav_bar_button :left, {
      title: "Back",
      image: UIImage.imageNamed("left-nav"),
      action: :back
    }
  end
  def on_load
    @layout = NewChatLayout.new(root: self.view)
    @layout.setController self
    @results_table = AttendeeSearchResults.new
    @results_table.controller = self
    @layout.results_view = @results_table.view
    @layout.chat_view = @chat_table.view
    @layout.build
    true
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
  def setChatFromPid(pid)
    setState 'loading'
    @msgs = []
    if @chat.nil? || !@chat
      @chat = Chat.new(pid)
    end
    startChat
  end
  def setChat(atn)
    setState 'loading'
    @msgs = []
    if @chat.nil? || !@chat
      @chat = Chat.new([atn, Me.atn])
    end
    if @layout.nil?
      @needsAtn = atn
    else
      @layout.setAttendee(atn)
      startChat
    end
  end
  def startChat
    @chat.whenReady do
      setState 'null'
      @chat.watch do |msg|
        setState 'loaded'
        update(msg)
      end
      @chat.watchTyping do |writing|
        @layout.setTyping(writing)
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
      @layout.setAttendees(atns)
      @layout.reapply!
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
    @layout.get(:msg_inp).text = ''
    @layout.updateMsgBoxSize(@layout.get(:msg_inp))
    # @layout.get(:msg_inp).resignFirstResponder
    @chat.send msg
  end
  def showLoadingMsg
    unless @layout.nil?
      @layout.get(:header_name).text = "Loading..."
      @layout.get(:loading_msg).setHidden false
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
      @layout.get(:chat_list).setHidden false
      @layout.get(:loading_msg).setHidden true
    end
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def close_action
    @layout.get(:msg_inp).resignFirstResponder
    @chat.unwatch
    @chat = false
    close_screen
  end
  def shouldAutorotate
    false
  end
end