class EventsLayout < MK::Layout
  view :events_view
  attr_accessor :daySelTop, :daySelHeight, :slid_up, :type
  def setController(controller)
    @controller = controller
  end
  def layout
    @type = 'meetup'
    @slid_up = false
    root :main do
      add UIView, :sub_nav do
        add PopupButton, :view_selector
        add PopupButton, :type_selector
      end
      add events_view, :events_list
      add UITextView, :null_msg
      add EventDaySelect, :day_selector
      add UIView, :host_shell do
        add UITextView, :host_head
        add UITextView, :host_text
        add UIButton, :host_close
      end
      add PopupLayout, :popup
      add ModalLayout, :modal
    end
    get(:view_selector).setPopup(get(:popup))
    get(:type_selector).setPopup(get(:popup))
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def slide_up(duration = 0.2)
    if !@slid_up and (@type == "meetup" || duration == 0)
      @slid_up = true
      @listTop.minus(46)
      @listHeight.plus(46)
      @subNavTop.minus(46)
      #@daySelTop.minus(46)
      UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
    end
  end
  def slide_down(duration = 0.2)
    if @slid_up and (@type == "meetup" || duration == 0)
      @slid_up = false
      @listTop.plus(46)
      @listHeight.minus(46)
      @subNavTop.plus(46)
      #@daySelTop.plus(46)
      UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
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
    text "Nice! Any attendee can host a meetup to bring their fellow attendees together.\n\nJust head to http://wds.fm/propose-a-meetup for more details.\n\n(Best performed on a laptop or desktop computer)"
    font Font.Karla(16)
    textColor Color.coffee
    dataDetectorTypes UIDataDetectorTypeLink
    editable false
    tintColor Color.orange
    scrollEnabled false
  end
  def sub_nav_style
    background_color Color.bright_green
    constraints do
      width.equals(:superview)
      height 46
      @subNavTop = top 63
      left 0
    end
    reapply do
      if @type == 'meetup'
        slide_down(0)
        hidden false
      else
        slide_up(0)
        hidden true
      end
    end
  end
  def popup_style
    hidden true
    constraints do
      top.equals(0)
      left.equals(0)
      width.equals(super_width)
      height.equals(super_height)
    end
  end
  def modal_style
    hidden true
    constraints do
      top.equals(0)
      left.equals(0)
      width.equals(super_width)
      height.equals(super_height)
    end
  end
  def view_selector_style
    target.setLabel 'View'
    target.setValues([
      {id: "browse", val: "Browse", long: "Browse Meetups"},
      {id: "attending", val: "Attending", long: "Meetups You're Attending"},
      {id: "suggested", val: "Suggested", long: "Suggestions for You"},
    ])
    target.setCallback('setMeetupState')
    target.setController(@controller)
    target.setTitle('Select Meetup View')
    opaque false
    constraints do
      width.equals(super_width/2).minus(10)
      left 10
      height 32
      top 8
    end
    layer do
      cornerRadius 6
    end
  end
  def type_selector_style
    target.setLabel 'Type'
    target.setValues([
      {id: "all", val: "All", long: "Show All Meetups"},
      {id: "discover", val: "Discover", long: "Discover"},
      {id: "experience", val: "Experience", long: "Experience"},
      {id: "network", val: "Network", long: "Network"},
    ])
    target.setController(@controller)
    target.setCallback('setMeetupType')
    target.setTitle('Select Meetup Type')
    opaque false
    constraints do
      width.equals(super_width/2).minus(20)
      left.equals(super_width/2).plus(10)
      height 32
      top 8
    end
  end
  def null_msg_style
    editable false
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
  def events_list_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      right "100%"
      @listTop = top 146
      if $IS8
        @listHeight = height.equals(:superview).minus(146)
      else
        @listHeight = height.equals(:superview).minus(193)
      end
    end
  end
end