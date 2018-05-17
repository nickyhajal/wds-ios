class AtnStoryLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def setAttendee(atn)
    @kb_height = 0
    @atn = atn
  end
  def status=(status)
    @status = status
    reapply!
  end
  def layout
    @status = 'waiting'
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
      end
      add UIScrollView, :scrollview do
        add UITextView, :msg
        add UIView, :sep
        add UIView, :phone_box do
          add UITextView, :phone_inp
          add UILabel, :phone_hint
        end
        add UIView, :story_box do
          add UITextView, :story_inp
          add UILabel, :story_hint
        end
        add UILabel, :story_count
        add UIButton, :submit
        add UIView, :anchor
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
    text "Share Your Story"
  end
  def scrollview_style
    scrollEnabled true
    delegate self
    contentSize [super_width, 900]
    constraints do
      top.equals(:header, :bottom)
      left 0
      width super_width
      @scrollH = height(super_height - 60)
    end
  end
  def msg_style
    editable false
    scrollEnabled false
    str = "Every year WDS Attendees take to the stage to share their stories of adventure, bravery, kindness and more.\n\nHave a story you’d like to share?\n\nLeave your phone number and a 250 character summary of your story below.\n\nWe’ll get in touch if we'll be able to feature your story.\n\n".attrd({
      NSFontAttributeName => Font.Karla(16),
      UITextAttributeTextColor => Color.dark_gray
    })
    imp = "You must be available to meet in person at 3PM on Saturday, July 15th".attrd({
      NSFontAttributeName => Font.Karla_Bold(16),
      UITextAttributeTextColor => Color.dark_gray
    })
    str = str + imp
    attributedText str
    backgroundColor Color.clear
    tv = target
    constraints do
      top 12
      left 12
      width (super_width-24)
      @msgHeight = height 0
      newSize =  tv.sizeThatFits(CGSizeMake((super_width-24), Float::MAX))
      @msgHeight.equals(newSize.height)
    end
  end
  def sep_style
    backgroundColor Color.orangish_gray(0.8)
    constraints do
      top.equals(:msg, :bottom).plus(12)
      left.equals(:msg, :left)
      right.equals(:msg, :right)
      height 3
    end
  end
  def phone_box_style
    backgroundColor Color.dark_gray(0.3)
    constraints do
      top.equals(:sep, :bottom).plus(12)
      left.equals(:msg, :left)
      right.equals(:msg, :right)
      height 40
    end
  end
  def phone_inp_style
    delegate self
    font Font.Karla(16)
    backgroundColor Color.white
    textColor Color.dark_gray
    constraints do
      top 1
      left 1
      right -1
      bottom -1
    end
  end
  def phone_hint_style
    text "Your Phone #"
    textColor Color.gray
    font Font.Karla(16)
    constraints do
      center_y.equals(:superview)
      left 12
      width.equals(:phone_inp).minus(24)
      height 18
    end
  end
  def story_box_style
    backgroundColor Color.dark_gray(0.3)
    constraints do
      top.equals(:phone_inp, :bottom).plus(12)
      left.equals(:msg, :left)
      right.equals(:msg, :right)
      height 120
    end
  end
  def story_inp_style
    delegate self
    font Font.Karla(16)
    backgroundColor Color.white
    textColor Color.dark_gray
    constraints do
      top 1
      left 1
      right -1
      bottom -1
    end
  end
  def story_count_style
    text "250"
    font Font.Karla_BoldItalic(14)
    textColor Color.blue
    textAlignment UITextAlignmentRight
    constraints do
      top.equals(:story_box, :bottom)
      right.equals(:story_box, :right)
      width 100
      height 30
    end
  end
  def story_hint_style
    text "Your Story Summary"
    textColor Color.gray
    font Font.Karla(16)
    constraints do
      top 12
      left 12
      width.equals(:phone_inp).minus(24)
      height 18
    end
  end
  def submit_style
    backgroundColor Color.orange
    titleColor Color.light_tan
    font Font.Vitesse_Bold(17)
    always do
      case @status
      when 'waiting'
        title "Send Your Story"
      when 'processing'
        title "Sending..."
      when 'success'
        title "Success!"
      when 'error'
        title "There was a problem."
      end
    end
    addTarget @controller, action: 'post_story_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top.equals(:story_box, :bottom).plus(82)
      left.equals(:msg, :left)
      right.equals(:msg, :right)
      height 40
    end
  end
  def anchor_style
    constraints do
      top.equals(:submit, :bottom)
      height 1
      width.equals(:superview)
      left 0
    end
  end
  def updateScrollSize
    frame = get(:anchor).frame
    bot_padding = 50
    height = frame.origin.y + frame.size.height + bot_padding
    get(:scrollview).contentSize = [super_width, height]
  end
  def updatePlaceholder(textView)
    if textView == get(:phone_inp)
      hint = get(:phone_hint)
    elsif textView == get(:story_inp)
      hint = get(:story_hint)
    end
    if textView.hasText
      hint.hidden = true
    else
      hint.hidden = false
    end
  end
  def textViewDidEndEditing(textView)
    updatePlaceholder(textView)
  end
  def textViewDidChange(textView)
    story = get(:story_inp).text

    diff = 250 - story.length
    if diff < 0
      get(:story_inp).text = story[0, 250]
      get(:story_count).text = 0.to_s
    else
      get(:story_count).text = diff.to_s
    end
    updatePlaceholder(textView)
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
    if dir
      @scrollH.equals(super_height-60)
    else
      @scrollH.equals(super_height-60-@kb_height)
    end
    updateScrollSize
    UIView.animateWithDuration(duration, delay: 0.0, options: curve, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
end