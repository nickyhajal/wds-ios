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
      add UITextView, :null_msg
      add MeetupDaySelect, :day_selector
      add UIView, :host_shell do
        add UITextView, :host_head
        add UITextView, :host_text
        add UIButton, :host_close
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def slide_up
    unless @slid_up
      @slid_up = true
      @listTop.minus(46)
      @listHeight.plus(46)
      @subNavTop.minus(46)
      #@daySelTop.minus(46)
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
      #@daySelTop.plus(46)
      UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
    end
  end
  def open_host
    get(:host_shell).setHidden false
    @host_w.equals(super_width-10)
    @host_h.equals(super_height-10)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def close_host
    @host_w.equals(0)
    @host_h.equals(0)
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    0.2.seconds.later do
      get(:host_shell).setHidden true
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def host_shell_style
    constraints do
      center_x.equals(:superview)
      center_y.equals(:superview).plus(50)
      @host_w = width 0
      @host_h = height 0
    end
    hidden true
    backgroundColor Color.white
    layer do
      masks_to_bounds true
      corner_radius 4.0
      opaque false
    end
  end
  def host_close_style
    target.setTitleColor Color.dark_gray, forState:UIControlStateNormal
    target.titleLabel.font = Font.Vitesse_Medium(22)
    target.setTitle "x", forState:UIControlStateNormal
    target.setContentEdgeInsets UIEdgeInsetsMake(2, 0, 0, 0)
    addTarget self, action: 'close_host', forControlEvents:UIControlEventTouchDown
    constraints do
      top 14
      right -9
      height 30
      width 30
    end
  end
  def host_head_style
    constraints do
      top 40
      left 10
      width super_width-20
      height 60
    end
    text "Want to host a meetup?"
    font Font.Karla_Italic(24)
    textColor Color.blue
    editable false
  end
  def host_text_style
    constraints do
      top 80
      left 10
      width super_width-20
      height 400
    end
    text "Nice! Any attendee can host a meetup to bring their fellow attendees together.\n\nJust head to http://wds.fm/propose-a-meetup for more details.\n\n(Best on a desktop computer)"
    font Font.Karla(16)
    textColor Color.coffee
    dataDetectorTypes UIDataDetectorTypeLink
    editable false
    tintColor Color.orange
    scrollEnabled false
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
    tintColor Color.white
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
  def null_msg_style
    hidden true
    text "No RSVPs...yet!"
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
  def day_selector_style
    get(:day_selector).setController @controller
    get(:day_selector).setLayout self
    constraints do
      width.equals(:superview)
      top.equals(:sub_nav, :bottom)
      #@daySelTop = top 109
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