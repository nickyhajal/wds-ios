class ChatDetailLayout < MK::Layout
  view :table, :chatters_view
  attr_accessor :chattersList, :atnModalBoxHeight
  def setController(controller)
    @controller = controller
  end
  def setResults(results)
    @results = results
  end
  def layout
    @chattersList ||= begin
      ch = ChattersHorizontalList.new
      ch
    end
    @chattersList.setController(@controller)
    self.chatters_view = @chattersList.view
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
      end
      add chatters_view, :chatters
      add UIButton, :leave_btn
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def updateChatters
    @chatters_height.equals(@controller.chatters.length > 0 ? 64 : 0)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def main_style
    background_color "#E7E7DD".uicolor
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
    always do
      text "Messages"
    end
  end
  def chatters_style
    backgroundColor "#F7F7F1".uicolor
    constraints do
      top Device.x(64, 28)
      left 0
      right 0
      @chatters_height = height 0
    end
  end
  def leave_btn_style
    backgroundColor Color.clear
    title 'Leave Chat'
    font Font.Karla_Bold(16)
    titleColor Color.dark_gray
    addTarget @controller, action: 'leave_action', forControlEvents:UIControlEventTouchDown
    constraints do
      width (super_width * 0.75)
      center_x.equals(:superview)
      top.equals(:chatters, :bottom).plus(40)
      height 45
    end
    layer do
      border_width 1
      border_color Color.orangish_gray(0.5).CGColor
      corner_radius 4
    end
  end
end