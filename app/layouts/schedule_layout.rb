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
      add MeetupDaySelect, :day_selector
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def day_selector_style
    get(:day_selector).setController @controller
    get(:day_selector).setLayout self
    constraints do
      width.equals(:superview)
      @daySelTop = top 63
      @daySelHeight = height 37
      left 0
    end
  end
  def null_msg_style
    hidden true
    text "Nothing scheduled...yet!"
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
  def schedule_style
    backgroundColor Color.tan
    constraints do
      left 0
      right "100%"
      top 100
      height.equals(:superview).minus(100)
    end
  end
  def main_style
    background_color "#000000".uicolor
  end
end