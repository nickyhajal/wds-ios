class ScheduleLayout < MK::Layout
  view :schedule_view
  attr_accessor :slid_up, :daySelTop, :daySelHeight
  def setController(controller)
    @controller = controller
  end

  def layout
    @slid_up = true
    root :main do
      add schedule_view, :schedule
      add UITextView, :null_msg
      add ScheduleDaySelect, :day_selector
    end
  end

  def super_height
    get(:main).frame.size.height
  end

  def super_width
    get(:main).frame.size.width
  end

  def main_style
    background_color "#F2F2EA".uicolor
  end

  def day_selector_style
    get(:day_selector).setController @controller
    get(:day_selector).setLayout self
    hidden false
    constraints do
      width.equals(:superview)
      @daySelTop = top Device.isX ? 88 : 63
      @daySelHeight = height 56
      left 0
    end
  end

  def null_msg_style
    hidden true
    editable false
    # text 'Nothing scheduled...yet!'
    # text 'Your complete WDS Schedule will be available here later in the year!'
    textColor Color.orangish_gray
    textColor Color.gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    paragraphStyle = NSMutableParagraphStyle.alloc.init
    paragraphStyle.lineSpacing = 5
    paragraphStyle.alignment = NSTextAlignmentCenter
    str = "Nothing scheduled...yet!".attrd({
      NSFontAttributeName => Font.Vitesse_Medium(17),
      UITextAttributeTextColor => Color.gray,
      NSParagraphStyleAttributeName => paragraphStyle
    })
    # str = "Your complete WDS Schedule will be available here later in the year!".attrd({
    #   NSFontAttributeName => Font.Vitesse_Medium(17),
    #   UITextAttributeTextColor => Color.gray,
    #   NSParagraphStyleAttributeName => paragraphStyle
    # })
    target.setAttributedText str
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end

  def schedule_style
    hidden false
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      right '100%'
      top (Device.isX ? 148 : 122)
      bottom.equals(:superview, :bottom)
      if $IS8
        height.equals(:superview).minus(124)
      else
        height.equals(:superview).minus(Device.isX ? 148 : 148)
      end
    end
  end

  def main_style
    background_color "#F2F2EA".uicolor
  end
end
