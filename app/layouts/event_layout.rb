# helped with the map: http://www.devfright.com/mkpointannotation-tutorial/
class EventLayout < MK::Layout
  include MapKit
  view :event_atn_view, :dispatch_view
  attr_accessor :dispatch, :new_posts_y
  def setController(controller)
    @controller = controller
  end
  def updateEvent(event, updateMap = true)
    @updateMap = updateMap
    @event = event
    @numAttendees = @event.num_rsvps.to_s
    self.reapply!
    if @event.type == 'program'
      @rsvpsHeight.equals(0)
      get(:rsvps).setHidden true
    else
      @rsvpsHeight.equals(32)
      get(:rsvps).setHidden false
    end
    Api.get 'event/attendees', {event_id: @event.event_id, include_users: 1} do |rsp|
      if rsp.is_err
        $APP.offline_alert
      else
        unless rsp.attendees.nil?
          @numAttendees = rsp.attendees.length.to_s
          @controller.loadAttendees rsp.attendees
          self.reapply!
        end
      end
    end
    0.05.seconds.later do
      updateScrollSize
    end
  end
  def layout
    @base_styles =  ' style="font-family: Graphik App; font-size:15px; color:#21170A; margin-left:8px; margin-right:8px;'
    @p_styles = @base_styles + ' margin-bottom:10px;"'
    @li_styles = @base_styles + ' margin-bottom:4px;"'
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
          add UIView, :scrollshell do
            add UITextView, :name
            add UILabel, :when
            add UILabel, :whenTime
            add UITextView, :venue
            add UITextView, :addr
            add UITextView, :venue_note
            add UIView, :line_after_when
            add EventHostView, :hosts
            add UITextView, :who
            add UIButton, :rsvps do
              add UIImageView, :rsvps_open
            end
            add UIButton, :dispatch_btn do
              add UIImageView, :dispatch_open
            end
            add UILabel, :descr_head
            add HTMLTextView, :descr
            add UIView, :anchor
          end
        end
        add UIView, :pan_catch
      end
      add UIView, :atns_shell do
        add UIButton, :atns_back
        add UILabel, :atns_header
        add UITextView, :atns_loading
        add event_atn_view, :atns
      end
      add UIView, :dispatch_shell do
        add dispatch_view, :dispatch
        add UIButton, :new_posts
        add DividedNav, :channel_nav
      end
      add ModalLayout, :modal
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
    background_color Color.light_tan
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
      top Device.x(20, 28)
      height 33
      width super_width
    end
  end
  def dispatch_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      top Device.x(53, 28)
      left 0
      width.equals(:superview)
      height.equals(super_height-Device.x(30, 28))
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
      top Device.x(26, 28)
      left 0
      width 38
      height 24
    end
    target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:Color.orange), forState:UIControlStateNormal)
    target.addTarget self, action: 'close_atns', forControlEvents:UIControlEventTouchDown
  end
  def atns_header_style
    constraints do
      top Device.x(26, 28)
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
      top Device.x(58, 28)
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
      height Device.x(60, 28)
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
    textColor Color.dark_gray
    reapply do
      text @event.what
    end
  end
  def header_back_style
    # target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:"#E99533".uicolor), forState:UIControlStateNormal)
    title 'x'
    font Font.Vitesse_Medium(18)
    titleColor Color.orange
    addTarget @controller, action: 'back_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top Device.x(19, 28)
      left 0
      width 40
      height 40
    end
  end
  def header_rsvp_style
    constraints do
      right 10
      top Device.x(20, 28)
      width 100
      height 40
    end
    reapply do
      if Me.isAttendingEvent @event
        if @event.type == 'academy'
          title "Joined"
        else
          title "unRSVP"
        end
      else
        if @event.isFull
          title "Full"
        else
          if @event.type == 'academy'
            title "Join"
          else
            title "RSVP"
          end
        end
      end
    end
    font Font.Vitesse_Medium(16)
    titleColor Color.orange
    target.addTarget @controller, action: 'open_confirm_action', forControlEvents:UIControlEventTouchDown
  end
  def map_line_top_style
    constraints do
      top Device.x(60, 28)
      # top 64
      left 0
      width.equals(:superview)
      height 4
    end
    backgroundColor "#848477".uicolor(0.1)
  end
  def main_content_style
    constraints do
      @scrollview_top = top Device.x(266, 28)
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
    map = target
    reapply do
      if !@event.lat.nil? && !@event.lon.nil? && @updateMap
        @updateMap = false
        map.region = CoordinateRegion.new([@event.lat.to_f+0.0004, @event.lon], [0.1, 0.1])
        map.set_zoom_level(15)
        0.1.seconds.later do
          map.region = CoordinateRegion.new([@event.lat.to_f+0.0004, @event.lon], [0.1, 0.1])
          map.set_zoom_level(15)
          map.removeAnnotations(map.annotations)
          pin = MKPointAnnotation.alloc.init
          pin.coordinate = CLLocationCoordinate2DMake(@event.lat, @event.lon)
          pin.title = @event.place
          pin.subtitle = @event.address.gsub(/, Portland, OR[\s0-9]*/, '')
          map.addAnnotation pin
        end
      end
    end
  end
  def scrollshell_style
    constraints do
      top 0
      left 0
      bottom 0
      right 0
      width.equals(:superview)
      @scroll_height = height 1
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
      y = gesture.locationInView(get(:superview)).y
      atnY = gesture.locationInView(get(:superview)).y - get(:name).frame.size.height - get(:who).frame.size.height
      hOr = get(:hosts).frame.origin
      hStart = hOr.y + 273
      hEnd = hStart + 31
      if ((!@slid_open || @slid_open.nil?) && y > hStart && y < hEnd)
        x = x - 78
        if x > 0
          get(:hosts).openByX(x)
        end
      end
      dOr = get(:dispatch_btn).frame.origin
      dStart = dOr.y + 273
      dEnd = dStart + 31
      rOr = get(:rsvps).frame.origin
      rStart = rOr.y + 273
      rEnd = rStart + 31
      if (!@slid_open && y > rStart && y < rEnd)
        open_atns
      end
      if (!@slid_open && y > dStart && y < dEnd)
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
      top Device.x(10, 0)
      left 15
      @name_height = height 0
      width.equals(:superview).minus(40)
    end
    font Font.Vitesse_Medium(26)
    textColor Color.bright_blue
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
    font Font.Karla_Bold(16)
    textColor "#848477".uicolor
    reapply do
      txt = ''
      if !@event.dayStr.nil?
        txt = @event.dayStr
      end
      text txt
    end
    constraints do
      top.equals(:name, :bottom).minus(12)
      width.equals(:superview).minus(40)
      height 30
      left.equals(:name).plus(8)
    end
  end
  def whenTime_style
    font Font.Karla_Bold(16)
    textColor "#848477".uicolor
    reapply do
      txt = ''
      if !@event.startStr.nil?
        txt += "from "+@event.startStr.gsub(' ', '')+" until "+@event.endStr.gsub(' ', '')
      end
      text txt
    end
    constraints do
      top.equals(:when, :bottom).minus(10)
      width.equals(:superview).minus(40)
      height 30
      left.equals(:name).plus(8)
    end
  end
  def venue_style
    font Font.Karla_Bold(16)
    textColor "#848477".uicolor
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    reapply do
      txt = ''
      if !@event.place.nil?
        txt = 'at '+@event.place
      end
      text txt
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @venue_height.equals(newSize.height)
    end
    constraints do
      @venue_top = top.equals(:whenTime, :bottom).minus(13)
      width.equals(:superview).minus(40)
      @venue_height = height 30
      left.equals(:name).plus(3)
    end
  end
  def addr_style
    font Font.Karla(16)
    textColor "#848477".uicolor
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    reapply do
      txt = ''
      if !@event.address.nil?
        addr = @event.address.sub(/portland.*or/i, "")
        addr = addr.sub(/972[0-9]{2}/, "")
        addr = addr.strip
        addr = addr.chomp(',')
        addr = addr.strip
        txt = addr
      end
      text txt
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @addr_height.equals(newSize.height)
    end
    constraints do
      @addr_top = top.equals(:venue, :bottom).minus(14)
      width.equals(:superview).minus(40)
      @addr_height = height 30
      left.equals(:name).plus(3)
    end
  end
  def venue_note_style
    font Font.Karla_Italic(16)
    textColor "#848477".uicolor
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    reapply do
      venue_note = ''
      venue_note = @event.venue_note unless @event.venue_note.nil?
      text venue_note.strip
      if venue_note.length > 0
        newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
        @venue_note_height.equals(newSize.height)
      else
        @venue_note_height.equals(0)
      end
    end
    constraints do
      @venue_note_top = top.equals(:addr, :bottom).minus(14)
      width.equals(:superview).minus(40)
      @venue_note_height = height 30
      left.equals(:name).plus(3)
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
      left.equals(:name)
      top.equals(:venue_note, :bottom).plus(10)
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
      str = ''
      who = @event.who
      if who.length > 0
        if @event.type != 'academy'
          who = "An event for " + who[0, 1].downcase + who[1..-1]
        end

        error_ptr = Pointer.new(:object)
        error_ptrM = Pointer.new(:object)
        content = MMMarkdown.HTMLStringWithMarkdown(who, error:error_ptrM)
        options =  {
          NSDocumentTypeDocumentAttribute => NSHTMLTextDocumentType,
          NSFontAttributeName => Font.Karla(16),
          UITextAttributeTextColor => Color.coffee
        }
        if @event.type == 'academy'
          content = "<p>You'll learn:</p>#{content}"
        end
        content = content.gsub('<p>', '<p'+@p_styles+'>')
        content = content.gsub('<li>', '<li'+@li_styles+'>')
        content = NSAttributedString.alloc.initWithData(
          content.dataUsingEncoding(NSUTF8StringEncoding),
          options:options,
          documentAttributes:nil,
          error:error_ptr
        )
        if (@event.type == "meetup" and !@event.format.nil?)
          format = @event.format.gsub(/(\w+)/) { |s| s.capitalize }
          content = (format+": ").attrd({
            NSFontAttributeName => Font.Karla_Bold(15),
            UITextAttributeTextColor => "#21170A".uicolor(@opacity)
          })+content
        end
        attributedText content
        newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
        @who_height.equals(newSize.height)
      end
    end
  end
  def rsvps_style
    addTarget self, action:'open_atns', forControlEvents:UIControlEventTouchDown
    constraints do
      top.equals(:line_after_when, :bottom).plus(4)
      left.equals(:name)
      @rsvpsHeight = height 32
      width.equals(:name)
    end
    contentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
    contentEdgeInsets UIEdgeInsetsMake(0, 10, 0, 0)
    backgroundColor Color.light_gray(0.4)
    titleColor Color.orange

    font Font.Karla_Bold(14)
    reapply do
      num = @numAttendees
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
    title "Open Event Dispatch"
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
  def descr_heading_style
  end
  def descr_style
    constraints do
      top.equals(:who, :bottom).plus(4)
      left.equals(:name).minus(10)
      @descr_height = height 40
      width.equals(:name).plus(8)
    end
    textView = target
    target.scrollView.scrollEnabled = false
    backgroundColor Color.clear
    reapply do
      str = @event.descr.attrd({
        NSFontAttributeName => Font.Karla(15)
      })
      error_ptr = Pointer.new(:object)
      error_ptrM = Pointer.new(:object)
      content = MMMarkdown.HTMLStringWithMarkdown(@event.descr, error:error_ptrM)
      options =  {
        NSDocumentTypeDocumentAttribute => NSHTMLTextDocumentType,
        NSFontAttributeName => Font.Karla(16),
        UITextAttributeTextColor => Color.coffee
      }
      content = content.gsub('<p>', '<p'+@p_styles+'>')
      content = content.gsub('<li>', '<li'+@li_styles+'>')
      textView.setText(content, false)
      str = @event.descr.attrd({
        NSFontAttributeName => Font.Karla(17)
      })
      rect = str.boundingRectWithSize(CGSizeMake(super_width-40,Float::MAX), options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height = rect.size.height.ceil + 70
      @descr_height.equals(height)
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
  def modal_style
    hidden true
    constraints do
      top.equals(0)
      left.equals(0)
      width.equals(super_width)
      height.equals(super_height)
    end
  end
  def shiftContent(shift)
    @scrollview_top.minus(shift)
    @scrollview_height.plus(shift)
  end
  def slideOpen(speed = 0.2)
    if @slid_open.nil?
      @slid_open = true
      shift = Device.x(56, 28)
      @scrollview_top.equals(shift)
      @scrollview_height.equals(super_height-shift)
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
    shift = Device.x(266, 0)
    @scrollview_top.equals(shift)
    @scrollview_height.equals(super_height-shift)
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
    @scroll_height.equals(height)
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
        rightButton = UIButton.alloc.initWithFrame(CGRectMake(0,0,45,45))
        rightButton.addTarget @controller, action:'go_to_directions_action', forControlEvents:UIControlEventTouchDown
        rightButton.setImage(Ion.imageByFont(:ios_navigate, size:24.5, color:"#B0BA1E".uicolor), forState:UIControlStateNormal)
        pinView.rightCalloutAccessoryView = rightButton
      end
      pinView
    else
      nil
    end
  end
end