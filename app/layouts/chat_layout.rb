class ChatLayout < MK::Layout
  attr_accessor :viewContext
  view :chat_view
  def setController(controller)
    @controller = controller
  end
  def setAttendee(atn)
    @readyForMessages = 'waiting'
    @atn = atn
    updTitle
    if @atn == 'support'
      @readyForMessages = 'support'
      reapply!
    else
      @atn.readyForMessages do |rsp|
        if @atn.first_name == 'WDS'
          @readyForMessages = 'support'
        else
          @readyForMessages = rsp
        end
        reapply!
      end
    end
  end
  def setAttendees(atns)
    if atns.length == 1
      @atn = atns[0]
    end
    updTitle
    @readyForMessages = 'waiting'
    @atn.readyForMessages do |rsp|
      if @atn.first_name == 'WDS'
        @readyForMessages = 'support'
      else
        @readyForMessages = rsp
      end
      reapply!
    end
  end
  def nameStr
    if @atn.nil?
      if @atn == 'support'
        'the WDS Team'
      elsif !@atn.first_name.nil?
         @atn.first_name == 'WDS' ? 'the WDS Team' : @atn.first_name
      else
        "your group"
      end
    else
      "your group"
    end
  end
  def titleStr
    if !@chat.nil? && @chat
      @chat.name
    else
      if @atn == 'support'
        name = 'WDS Team'
      else
        name = @atn.nil? || @atn.first_name.nil? ? 'Chat' : "#{@atn.first_name} #{@atn.last_name}"
      end
    end
  end
  def updTitle
    title = titleStr
    if title.length > 18
      title = title[0..7]+'...'+title[title.length-8..title.length-1]
    end
    @controller.title = title
  end
  def setTyping(typing)
    @typing = typing
    reapply!
  end
  def setChat(chat)
    @chat = chat
    @readyForMessages = 'group'
    updTitle
  end
  def state=(state)
    @state = state
    unless @layout.get(:null_msg).nil?
      @layout.get(:null_msg).setHidden true
      @layout.get(:chat_list).setHidden false
      @layout.get(:loading_list).setHidden true
    end
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
      add UIView, :typing_shell do
        add UILabel, :typing_label
      end
      add UIView, :msg_box do
        add UIView, :msg_line
        add UITextView, :msg_inp
        add UILabel, :placeholder
        add UIButton, :msg_btn
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
    background_color Color.bright_blue
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height Device.x(60, 28)
    end
  end
  def header_back_style
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(18)
    target.on_tap do |gesture|
      @controller.close_action(true)
    end
    constraints do
      top Device.x(20, 28)
      left 0
      width 38
      height 38
    end
  end
  def header_name_style
    header_width = (super_width - 170)
    constraints do
      top Device.x(20, 28)
      left (super_width/2 - header_width/2)
      width header_width
      height 40
    end
    font Font.Vitesse_Medium(16)
    textAlignment UITextAlignmentCenter
    textColor Color.light_tan
    reapply do
      text titleStr
    end
  end
  def null_msg_style
    hidden true
    editable false
    reapply do
      str = "Send a message to "+nameStr+" below."
      pgraph = NSMutableParagraphStyle.alloc.init
      pgraph.alignment = NSTextAlignmentCenter
      str = str.attrd({
        NSFontAttributeName => Font.Vitesse_Medium(17),
        UITextAttributeTextColor => Color.orangish_gray,
        NSParagraphStyleAttributeName => pgraph
      })
      status = ""
      if @readyForMessages == "ready"
        status = "\n\n"+@atn.first_name+" has installed the latest WDS App and will receive your message immediately."
      elsif @readyForMessages == "not-ready"
        status = "\n\n"+@atn.first_name+" hasn't installed the latest WDS App but will receive your messages once they do."
      elsif @readyForMessages == "group"
        status = "\n\n"+"Woohoo, your group is ready to chat!"
      elsif @readyForMessages == "support"
        status = "\n\n"+"Need help? Send a message below and the WDS Team will get back to you as quickly as we can."
      end
      str += status.attrd({
        NSFontAttributeName => Font.Karla_Italic(14),
        UITextAttributeTextColor => Color.orangish_gray,
        NSParagraphStyleAttributeName => pgraph
      })
      attributedText str
    end
    font Font.Vitesse_Medium(17)
    textColor Color.orangish_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
  def loading_msg_style
    hidden true
    editable false
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.alignment = NSTextAlignmentCenter
    str = "Loading".attrd({
      NSFontAttributeName => Font.Vitesse_Medium(17),
      UITextAttributeTextColor => Color.orangish_gray,
      NSParagraphStyleAttributeName => pgraph
    })
    attributedText str
    font Font.Vitesse_Medium(17)
    textColor Color.orangish_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
  def chat_list_style
    backgroundColor Color.tan
    target.rotate_to Math::PI, {duration: 0}
    constraints do
      left 0
      width super_width
      top.equals(:header, :bottom)
      bottom.equals(:typing_shell, :top)
      # @listHeight = height.equals(:superview).minus(146)
    end
  end
  def typing_shell_style
    tv = target
    backgroundColor Color.clear
    constraints do
      width.equals(:superview)
      left 0
      @typingH = height 0
      bottom.equals(:msg_box, :top)
    end
    reapply do
      if !@typing.nil? and @typing.length > 0
        tv.fade_in
        @typingH.equals(36)
      else
        tv.fade_out
        @typingH.equals(0)
      end
      UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded
      end, completion: nil)
    end
  end
  def typing_label_style
    tv = target
    label = target
    text ""
    backgroundColor "#F7F7E9".uicolor
    textColor Color.gray
    font Font.Karla_Italic(14)
    textAlignment UITextAlignmentCenter
    clipsToBounds true
    constraints do
      @typingTop = top 2
      height 28
      center_x.equals(:superview)
      width super_width * 0.75
    end
    layer do
      cornerRadius 16.0
      shadow_color Color.coffee
      shadow_radius 3
      shadow_opacity 0.12
      shadow_offset [1,1]
    end
    reapply do
      if @typing
        tv.fade_in
        label.text = @typing
      else
        tv.fade_out
        label.text = ""
      end
    end
  end
  def msg_box_style
    backgroundColor Color.white
    constraints do
      @msg_box_height = height 40
      @msg_box_bottom = bottom 0
      width super_width
      left 0
    end
  end
  def msg_btn_style
    titleColor Color.orangish_gray
    font Font.Karla_Bold(15)
    backgroundColor Color.clear
    title "Send"
    alpha 0
    addTarget @controller, action: 'post_msg_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right -6
      width 60
      top 6
      height 28
    end
    layer do
      border_width 1
      border_color Color.orangish_gray(0.5).CGColor
      corner_radius 4.0
    end
    target.sizeToFit
  end
  def msg_line_style
    backgroundColor Color.light_gray(0.6)
    constraints do
      width.equals super_width
      height 1
      top 0
      left 0
    end
  end
  def msg_inp_style
    delegate self
    font Font.Karla(15)
    backgroundColor Color.white
    constraints do
      height.equals(:msg_box).minus(10)
      top 7
      width super_width - 72
      left 2
    end
  end
  def placeholder_style
    reapply do
      text "Send a message to "+nameStr+"..."
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
  def updatePlaceholder
    textView = get(:msg_inp)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
  end
  def textViewDidEndEditing(textView)
    updatePlaceholder
    updatePostButton
  end
  def textViewDidChange(textView)
    updatePlaceholder
    updatePostButton
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
  def updatePostButton
    inp = get(:msg_inp)
    btn = get(:msg_btn)
    if inp.text.length > 0
      btn.backgroundColor = Color.orange
      btn.titleColor = Color.white
      btn.layer.borderWidth = 0
    else
      btn.backgroundColor = Color.clear
      btn.titleColor = Color.orangish_gray
      btn.layer.borderWidth = 1.0
    end
  end
  def updateMsgBoxSize(textView)
    max = (super_height - @kb_height) * 0.5
    height = textView.contentSize.height+6
    height = 40 if height < 40
    height = max if height > max
    @msg_box_height.equals(height)
    textView.contentOffset = CGPointMake(0, 3)
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
    if !@viewContext.nil? && @viewContext == 'navview'
      @kb_height -= 49
    end
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