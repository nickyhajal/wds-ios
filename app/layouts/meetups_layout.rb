class MeetupsLayout < MK::Layout
  view :meetup_view
  attr_accessor :daySelTop, :daySelHeight, :slid_up
  def setController(controller)
    @controller = controller
  end
  def layout
    @slid_up = false
    root :main do
      add UIView, :sub_nav do
        add UISegmentedControl, :subview_selector
      end
      add meetup_view, :meetup_list
      add MeetupDaySelect, :day_selector
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def slide_up
    unless @slid_up
      @slid_up = true
      @listTop.minus(46)
      @listHeight.plus(46)
      @subNavTop.minus(46)
      @daySelTop.minus(46)
      UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
    end
  end
  def slide_down
    if @slid_up
      @slid_up = false
      @listTop.plus(46)
      @listHeight.minus(46)
      @subNavTop.plus(46)
      @daySelTop.plus(46)
      UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def sub_nav_style
    background_color "#BDC72B".uicolor
    constraints do
      width.equals(:superview)
      height 46
      @subNavTop = top 63
      left 0
    end
  end
  def subview_selector_style
    target.segmentedControlStyle = UISegmentedControlStyleBar
    target.insertSegmentWithTitle 'Browse', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Attending', atIndex:1, animated:false
    target.insertSegmentWithTitle 'Suggested', atIndex:2, animated:false
    target.selectedSegmentIndex = 0
    target.addTarget @controller, action: 'change_view_action:', forControlEvents:UIControlEventValueChanged
    tintColor "#FFFFFFF".uicolor
    attributes = {
      UITextAttributeFont => UIFont.fontWithName('Karla-Bold', size:15)
    }
    titleTextAttributes attributes, forState:UIControlStateNormal
    constraints do
      width.equals(:superview).minus(40)
      left 20
      height 30
      top 8
    end
    target.sizeToFit
  end
  def day_selector_style
    get(:day_selector).setController @controller
    get(:day_selector).setLayout self
    constraints do
      width.equals(:superview)
      @daySelTop = top 109
      @daySelHeight = height 37
      left 0
    end
  end
  def meetup_list_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      right "100%"
      @listTop = top 146
      @listHeight = height.equals(:superview).minus(146)
    end
  end
end  