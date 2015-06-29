# This helped with the map: http://www.devfright.com/mkpointannotation-tutorial/
class MeetupLayout < MK::Layout
  include MapKit
  view :meetup_atn_view, :dispatch_view
  attr_accessor :dispatch, :new_posts_y
  def setController(controller)
    @controller = controller
  end
  def updateEvent(event, updateMap = true)
    @updateMap = updateMap
    @event = event
    self.reapply!
    0.05.seconds.later do
      updateScrollSize
    end
  end
  def layout
    root :main do
      add MapView, :map
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
        add UIButton, :header_rsvp
      end
      add UIView, :map_line_top
      add UIView, :main_content do
        add UIView, :map_line_bot
        add UIScrollView, :scrollview do
          add UITextView, :name
          add UILabel, :when
          add UIView, :line_after_when
          add MeetupHostView, :hosts
          add UITextView, :who
          add UIButton, :rsvps do
            add UIImageView, :rsvps_open
          end
          add UIButton, :dispatch_btn do
            add UIImageView, :dispatch_open
          end
          add HTMLTextView, :descr
          add UIView, :anchor
        end
        add UIView, :pan_catch
      end
      add UIView, :atns_shell do
        add UIButton, :atns_back
        add UILabel, :atns_header
        add UITextView, :atns_loading
        add meetup_atn_view, :atns
      end
      add UIView, :dispatch_shell do
        add dispatch_view, :dispatch
        add UIButton, :new_posts
        add DividedNav, :channel_nav
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
    background_color Color.light_tan
  end
  def dispatch_shell_style
    background_color Color.green
    constraints do
      top 0
      @dispatch_left = left super_width
      width super_width
      height super_height
    end
  end
  def new_posts_style
    font Font.Karla_Bold(15)
    titleColor Color.light_tan
    backgroundColor Color.green
    hidden true
    target.addTarget @controller, action: 'load_new_action', forControlEvents:UIControlEventTouchDown
    constraints do
      width 120
      height 30
      center_x.equals(:superview)
      @new_posts_y = bottom.equals(:channel_nav, :bottom)
    end
    layer do
      cornerRadius 15
    end
  end
  def channel_nav_style
    target.setSize super_width, 33
    buttons [
      ['x', @controller, 'leave_channel_action', {width: 40}],
      ['Channel', @controller, 'show_communities_action'],
      ['Share a Post', @controller, 'show_post_action', {width: 120}]
    ]
    constraints do
      left 0
      top 20
      height 33
      width super_width
    end
  end
  def dispatch_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      top 53
      left 0
      width.equals(:superview)
      height.equals(super_height-30)
    end
    @dispatch.setWidth(super_width)
  end
  def atns_shell_style
    background_color Color.light_tan
    constraints do
      top 0
      @atns_left = left super_width
      width super_width
      height super_height
    end
  end
  def atns_back_style
    constraints do
      top 26
      left 0
      width 38
      height 24
    end
    target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:Color.orange), forState:UIControlStateNormal)
    target.addTarget self, action: 'close_atns', forControlEvents:UIControlEventTouchDown
  end
  def atns_header_style
    constraints do
      top 26
      left 0
      width.equals(:superview)
      height 32
    end
    font Font.Vitesse_Medium(16)
    textAlignment UITextAlignmentCenter
    textColor Color.dark_gray
    text "Attendees"
  end
  def atns_loading_style
    constraints do
      top 120
      left 0
      width.equals(:superview)
      height 34
    end
    backgroundColor Color.clear
    font Font.Karla_Italic(18)
    textAlignment UITextAlignmentCenter
    textColor Color.dark_gray
    text "Loading..."
  end
  def atns_style
    hidden true
    constraints do
      top 58
      left 0
      width super_width
      height super_height - 58
    end
  end
  def header_style
    background_color Color.light_tan(0.95)
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height 60
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
    textColor Color.dark_gray
    reapply do
      text @event.what
    end
  end
  def header_back_style
    #target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:"#E99533".uicolor), forState:UIControlStateNormal)
    title 'x'
    font Font.Vitesse_Medium(18)
    titleColor Color.orange
    addTarget @controller, action: 'back_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 19
      left 0
      width 40
      height 40
    end
  end
  def header_rsvp_style
    constraints do
      right 10
      top 20
      width 100
      height 40
    end
    reapply do
      if Me.isAttendingEvent @event
        title "unRSVP"
      else
        if @event.isFull
          title "Full"
        else
          title "RSVP"
        end
      end
    end
    font Font.Vitesse_Medium(16)
    titleColor Color.orange
    target.addTarget @controller, action: 'rsvp_action', forControlEvents:UIControlEventTouchDown
  end
  def map_line_top_style
    constraints do
      top 60
      #top 64
      left 0
      width.equals(:superview)
      height 4
    end
    backgroundColor "#848477".uicolor(0.1)
  end
  def main_content_style
    constraints do
      @scrollview_top = top 266
      @scrollview_height = height super_height-266
      left 0
      width super_width
    end
  end
  def map_line_bot_style
    constraints do
      top 0
      left 0
      width.equals(:superview)
      @map_line_height = height 4
    end
    backgroundColor "#848477".uicolor(0.1)
  end
  def map_style
    constraints do
      width.equals(:superview)
      height 270
      top 0
      left 0
    end
    delegate self
    reapply do
      if !@event.lat.nil? && !@event.lon.nil? && @updateMap
        @updateMap = false
        target.region = CoordinateRegion.new([@event.lat.to_f+0.0004, @event.lon], [0.1, 0.1])
        target.set_zoom_level(15)
        target.removeAnnotations(target.annotations)
        pin = MKPointAnnotation.alloc.init
        pin.coordinate = CLLocationCoordinate2DMake(@event.lat, @event.lon)
        pin.title = @event.place
        pin.subtitle = @event.address.gsub(/, Portland, OR[\s0-9]*/, '')
        target.addAnnotation pin
      end
    end
  end
  def scrollview_style
    scrollEnabled true
    delegate self
    contentSize [super_width, 900]
    backgroundColor Color.white
    constraints do
      top 4
      height.equals(:main_content).minus(4)
      left 0
      width.equals(:superview)
    end
  end
  def pan_catch_style
    constraints do
      width.equals(:main_content)
      height.equals(:main_content)
      top 0
      left 0
    end
    view = target
    target.on_tap do |gesture|
      x = gesture.locationInView(get(:superview)).x
      y = gesture.locationInView(get(:superview)).y - get(:name).frame.size.height
      atnY = gesture.locationInView(get(:superview)).y - get(:name).frame.size.height - get(:who).frame.size.height
      if (!@slid_open && y > 301 && y < 339) || (@slid_open && y > 91 && y < 130 )
        x = x - 78
        if x > 0
          get(:hosts).openByX(x)
        end
      end
      if (!@slid_open && y > 357 && y < 389) || (@slid_open && y > 146 && y < 176)
        open_atns
      end
      if (!@slid_open && y > 392 && y < 423) || (@slid_open && y > 181 && y < 212)
        open_dispatch
      end
    end
    target.on_pan do |gesture|
      @slid_up.nil?
      y = gesture.locationInView(get(:superview)).y
      if gesture.state == UIGestureRecognizerStateBegan
        @startPan = y
        @lastPan = @startPan
      end
      if gesture.state == UIGestureRecognizerStateEnded
        if @slid_open.nil?
          if @startPan - y > 40
            slideOpen
          else
            slideClosed
          end
        else
          if (@startPan - y) < -30
            slideClosed
          else
            @slid_open = nil
            slideOpen
          end
        end
        @startPan = false
      end
      if @startPan
        diff = @startPan - y
        lastDiff = @lastPan - y
        @lastPan = y
        if @slid_open.nil?
          if diff > 0
            shiftContent lastDiff
          end
          if diff > 50
            slideOpen
          end
        else
          if diff < 0
            shiftContent lastDiff
          end
          if diff < -50
            slideClosed
          end
        end
      end
    end
  end
  def name_style
    constraints do
      top 10
      left 15
      @name_height = height 0
      width.equals(:superview).minus(40)
    end
    font UIFont.fontWithName('Vitesse-Medium', size:26)
    textColor "#0A72B0".uicolor
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    reapply do
      text @event.what
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @name_height.equals(newSize.height)
    end
  end
  def when_style
    font UIFont.fontWithName('Karla', size:16)
    textColor "#848477".uicolor
    reapply do
      txt = ''
      if !@event.dayStr.nil?
        txt = @event.dayStr
      end
      if !@event.startStr.nil?
        txt += " at "+@event.startStr
      end
      text txt
    end
    constraints do
      @when_top = top.equals(:name, :bottom).minus(15)
      width.equals(:superview)
      height 30
      left.equals(:name).plus(4)
    end
  end
  def line_after_when_style
    backgroundColor Color.light_gray
    constraints do
      left.equals(:name)
      width.equals(:name)
      height 6
      top.equals(:hosts, :bottom).plus(7)
    end
  end
  def hosts_style
    backgroundColor NSColor.clearColor
    get(:hosts).controller = @controller
    constraints do
      left.equals(:when)
      top.equals(:when, :bottom).plus(5)
      width.equals(:name)
      height 37
    end
    reapply do
      event @event
    end
  end
  def who_style
    constraints do
      top.equals(:dispatch_btn, :bottom).plus(15)
      left.equals(:name)
      @who_height = height 0
      width.equals(:name)
    end
    font Font.Karla_Bold(15)
    textColor Color.coffee
    fixedWidth = super_width-40
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    textView = target
    reapply do
      who = @event.who
      text "A meetup for " + who[0, 1].downcase + who[1..-1]
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @who_height.equals(newSize.height)
    end
  end
  def rsvps_style
    addTarget self, action:'open_atns', forControlEvents:UIControlEventTouchDown
    constraints do
      top.equals(:line_after_when, :bottom).plus(4)
      left.equals(:name)
      height 32
      width.equals(:name)
    end
    contentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
    contentEdgeInsets UIEdgeInsetsMake(0, 10, 0, 0)
    backgroundColor Color.light_gray(0.4)
    titleColor Color.orange

    font Font.Karla_Bold(14)
    reapply do
      num = @event.num_rsvps.to_s
      atns = num == '1' ? 'WDSer' : 'WDSers'
      title num+' '+atns+' Attending'
    end
  end
  def rsvps_open_style
    constraints do
      right 0
      top 6
      height 20
      width 18
    end
    target.setImage Ion.imageByFont(:ios_arrow_forward, size:24, color:Color.orange)
  end
  def dispatch_btn_style
    target.addTarget self, action:'open_dispatch', forControlEvents:UIControlEventTouchDown
    constraints do
      top.equals(:rsvps, :bottom).plus(4)
      left.equals(:name)
      height 32
      width.equals(:name)
    end
    contentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
    contentEdgeInsets UIEdgeInsetsMake(0, 10, 0, 0)
    backgroundColor Color.light_gray(0.4)
    titleColor Color.orange
    font Font.Karla_Bold(14)
    title "Open Meetup Dispatch"
  end
  def dispatch_open_style
    constraints do
      right 0
      top 6
      height 20
      width 18
    end
    target.setImage Ion.imageByFont(:ios_arrow_forward, size:24, color:Color.orange)
  end
  def descr_style
    constraints do
      top.equals(:who, :bottom).plus(4)
      left.equals(:name)
      @descr_height = height 40
      width.equals(:name)
    end
    textView = target
    target.scrollView.scrollEnabled = false
    backgroundColor Color.clear
    reapply do
      str = @event.descr.attrd({
        NSFontAttributeName => Font.Karla(15)
      })
      rect = str.boundingRectWithSize(CGSizeMake(super_width-40,Float::MAX), options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height = rect.size.height.ceil + 60
      @descr_height.equals(height)
      textView.setText @event.descr
    end
  end
  def anchor_style
    constraints do
      top.equals(:descr, :bottom)
      height 1
      width.equals(:superview)
      left 0
    end
  end
  def shiftContent(shift)
    @scrollview_top.minus(shift)
    @scrollview_height.plus(shift)
  end
  def slideOpen(speed = 0.2)
    if @slid_open.nil?
      @slid_open = true
      @scrollview_top.equals(56)
      @scrollview_height.equals(super_height-56)
      @map_line_height.equals(0)
      UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
      if @contentHeight > (super_height - 60)
        get(:pan_catch).setHidden true
      end
    end
  end
  def slideClosed(speed = 0.2)
    @slid_open = nil
    @scrollview_top.equals(266)
    @scrollview_height.equals(super_height-266)
    @map_line_height.equals(4)
    UIView.animateWithDuration(speed, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    get(:pan_catch).setHidden false
  end
  def updateScrollSize
    frame = get(:anchor).frame
    bot_padding = 50
    height = frame.origin.y + frame.size.height + bot_padding
    @contentHeight = height
    get(:scrollview).setContentSize([super_width, height])
  end
  def open_dispatch
    @dispatch_left.equals(0)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def close_dispatch
    @dispatch_left.equals(super_width)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def open_atns
    @atns_left.equals(0)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    Api.get 'event/attendees', {event_id: @event.event_id, include_users: 1} do |rsp|
      if rsp.is_err
        $APP.offline_alert
        close_atns
      else
        @controller.loadAttendees rsp.attendees
      end
    end
  end
  def close_atns
    @atns_left.equals(super_width)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    0.4.seconds.later do
      get(:atns_loading).setHidden false
      get(:atns).setHidden true
    end
  end

  ## ScrollView Delegate
  def scrollViewDidScroll(scrollView)
    y = scrollView.contentOffset.y
    if y < -20
      slideClosed
    end
  end

  ## MapView delegate
  def mapView(mapView, didAddAnnotationViews:views)MKPointAnnotation
    mapView.selectAnnotation(mapView.annotations.lastObject, animated:true)
  end
  def mapView(mapView, viewForAnnotation:annotation)
    if annotation.class.to_s.include?('MKPointAnnotation')
      pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("LocationView")
      if pinView
        pinView.annotation = annotation
      else
        pinView = MKAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:"LocationView")
        pinView.canShowCallout = true
        rightButton = UIButton.alloc.initWithFrame(CGRectMake(0,0,30,30))
        rightButton.addTarget @controller, action:'go_to_directions_action', forControlEvents:UIControlEventTouchDown
        rightButton.setImage(Ion.image(:ios_navigate, color:"#B0BA1E".uicolor), forState:UIControlStateNormal)
        pinView.rightCalloutAccessoryView = rightButton
      end
      pinView
    else
      nil
    end
  end
end