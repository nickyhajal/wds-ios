class NewChatLayout < MK::Layout
  view :chat_view
  def setController(controller)
    @controller = controller
  end
  def layout
    @slid_up = false
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
      end
      add chat_view, :chat_list
      add UITextView, :null_msg
      add UITextView, :loading_msg
      add UIView, :msg_box do
        add UIView, :msg_line
        add UITextView, :msg_inp
        add UILabel, :placeholder
        add UIButton, :msg_btn
      end
      add UIView, :typing_shell do
        add UILabel, :typing_label
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.tan
  end
  def header_style
    background_color Color.green
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height 60
    end
  end
  def header_back_style
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(18)
    addTarget @controller, action: 'close_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 20
      left 0
      width 38
      height 38
    end
  end
  def header_name_style
    header_width = (super_width - 170)
    constraints do
      top 20
      left (super_width/2 - header_width/2)
      width header_width
      height 40
    end
    font Font.Vitesse_Medium(16)
    textAlignment UITextAlignmentCenter
    textColor Color.light_tan
    reapply do
      text "Chat with "+@atn.first_name
    end
  end
  def placeholder_style
    reapply do
      text "Send a message to "+@atn.first_name+"..."
    end
    textColor Color.gray
    font Font.Karla(15)
    constraints do
      top 0
      left 6
      width super_width
      height 40
    end
  end
  def textViewDidEndEditing(textView)
    updatePlaceholder
  end
  def textViewDidChange(textView)
    updatePlaceholder
    updateMsgBoxSize(textView)
    unless @typingTimer.nil?
      @typingTimer.invalidate
    end
    if !@controller.chat.nil? and @controller.chat
      @controller.chat.setTyping(true)
    end
    @typingTimer = 2.seconds.later do
      if !@controller.chat.nil? and @controller.chat
        @controller.chat.setTyping(false)
      end
    end
  end
  def updateMsgBoxSize(textView)
    max = (super_height - @kb_height) * 0.5
    height = textView.contentSize.height+6
    height = 40 if height < 40
    height = max if height > max
    @msg_box_height.equals(height)
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def moveInput(notification, dir = false)
    info = notification.userInfo
    kbFrame = info[:UIKeyboardFrameEndUserInfoKey].CGRectValue
    if info[:UIKeyboardAnimationDurationUserInfoKey].nil?
      duration = 0.25
    else
      duration = info[:UIKeyboardAnimationDurationUserInfoKey].to_f
    end
    if info[:UIKeyboardAnimationCurveUserInfoKey].nil?
      curve = 0
    else
      curve = info[:UIKeyboardAnimationCurveUserInfoKey].to_i << 16
    end
    @kb_height = kbFrame.size.height
    unless dir
      @msg_box_bottom.equals(@kb_height * -1)
      get(:msg_btn).alpha = 1
      get(:null_msg).alpha = 0
    else
      @msg_box_height.equals(40)
      @msg_box_bottom.equals(0)
      get(:msg_btn).alpha = 0
      get(:null_msg).alpha = 1
    end
    UIView.animateWithDuration(duration, delay: 0.0, options: curve, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
end