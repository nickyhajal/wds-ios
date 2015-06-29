class ScheduleCell < PM::TableViewCell
  attr_accessor :event, :width, :controller
  def initWithStyle(style, reuseIdentifier:id)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    @_event = false
    super
  end
  def will_display
    self.setNeedsDisplay
  end
  def getHeight
    size = self.frame.size
    size.width = @width - 50
    size.height = Float::MAX
    if @navView.nil?
      @navView = UIButton.alloc.initWithFrame([[0,0], [18,18]])
      @navView.setImage Ion.image(:navigate, color:Color.orangish_gray), forState:UIControlStateNormal
      @navView.addTarget self, action: 'nav_action', forControlEvents: UIControlEventTouchDown
      self.addSubview @navView
      @moreView = UIButton.alloc.initWithFrame([[0,0], [24,24]])
      @moreView.setImage Ion.image(:ios_arrow_forward, color:Color.orange), forState:UIControlStateNormal
      @moreView.addTarget self, action: 'open_meetup_action', forControlEvents: UIControlEventTouchDown
      self.addSubview @moreView
    end
    what = @event['what']
    type = @event['type']
    if type == 'meetup'
      what = 'Meetup: '+what
    elsif type == 'academy'
      what = 'Academy: '+what
    end
    puts what
    wrap_p = NSMutableParagraphStyle.alloc.init
    wrap_p.lineBreakMode = NSLineBreakByWordWrapping
    @whatStr = what.nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Medium(19),
      NSParagraphStyleAttributeName => wrap_p,
      UITextAttributeTextColor => Color.blue
    })
    @what = @whatStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    @placeStr = @event['place'].nsattributedstring({
      NSFontAttributeName => Font.Karla(16),
      UITextAttributeTextColor => Color.dark_gray
    })
    size.width -= 25
    @place = @placeStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    return 10+10+8+@what.size.height+@place.size.height
  end
  def nav_action
    chrome = "comgooglemaps://"
    chromeURL = NSURL.URLWithString(chrome)
    destination = @event['lat'].to_s+','+@event['lon'].to_s
    if UIApplication.sharedApplication.canOpenURL(chromeURL)
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(chrome+'?daddr='+destination+'&directionsmode=walking'))
    else
      place = MKPlacemark.alloc.initWithCoordinate(CLLocationCoordinate2DMake(@event['lat'], @event['lon']), addressDictionary: nil)
      item = MKMapItem.alloc.initWithPlacemark(place)
      item.setName(@event['place'])
      currentLocationMapItem = MKMapItem.mapItemForCurrentLocation
      launchOptions = {
        MKLaunchOptionsDirectionsModeKey => MKLaunchOptionsDirectionsModeWalking
      }
      MKMapItem.openMapsWithItems([currentLocationMapItem, item], launchOptions: launchOptions)
    end
  end
  def open_meetup_action
    if @event['type'] == 'meetup'
      @controller.open_meetup(Event.new(@event))
    end
  end
  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    y = pnt.y
    x = pnt.x
    size = self.frame.size
    width = size.width
    height = size.height

    if x > 10 && x < width - 30
      if y > 10 && y < @what.size.height+10 && x < @what.size.width+10
        open_meetup_action
      end
      if y > @what.size.height+10 && y < height - 10 && x < @place.size.width+10
        nav_action
      end
    end
  end
  def drawRect(rect)
    # Init
    @_event = Event.new(@event)
    height = getHeight
    size = rect.size

    # Colors
    orange = Color.orange
    white = Color.white
    tan = "#f8f8f2".uicolor
    darkTan = Color.yellowish_tan
    grey = "#231f20".uicolor

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius:0.0)
    white.setFill
    bgPath.fill

    @whatStr.drawInRect(CGRectMake(15, 12, size.width-50, Float::MAX))
    @placeStr.drawInRect(CGRectMake(40, 17+@what.size.height, size.width-75, Float::MAX))
    unless @navView.nil?
      frame = @navView.frame
      frame.origin.x = 15
      frame.origin.y = 19+@what.size.height
      @navView.setFrame frame
      if (@event['type'] == "meetup")
        frame = @moreView.frame
        frame.origin.x = @width-28
        frame.origin.y = height/2 - 10
        @moreView.setFrame frame
        @moreView.setHidden false
      else
        @moreView.setHidden true
      end
    end
  end
end
