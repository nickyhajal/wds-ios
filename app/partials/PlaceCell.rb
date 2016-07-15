class PlaceCell < PM::TableViewCell
  attr_accessor :place, :width, :controller, :checkinScreen, :checkinMessage, :onPicked, :checkin, :checkinStr, :nameStr, :addrStr, :metaStr, :pickStr
  def initWithStyle(style, reuseIdentifier:id)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    @checkinMessage = "Check In"
    super
  end
  def will_display
    self.setNeedsDisplay
  end
  def getHeight
    if @cardView.nil?
      @cardView = PlaceCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @cardView.cell = self
      self.addSubview(@cardView)
    end
    size = self.frame.size
    size.width = @width - 6 - 40
    if @checkinScreen
      size.width -= 80
    end
    size.height = Float::MAX
    metaHeight = 0
    height = 10+10 # Top and bottom padding

    # Nav View
    if @navView.nil? && !@checkinScreen
      @navView = UIButton.alloc.initWithFrame([[0,0], [18,18]])
      @navView.setImage Ion.image(:navigate, color:Color.orangish_gray), forState:UIControlStateNormal
      @navView.addTarget self, action: 'nav_action', forControlEvents: UIControlEventTouchDown
      @cardView.addSubview @navView
      @moreView = UIButton.alloc.initWithFrame([[0,0], [24,24]])
      @moreView.setImage Ion.image(:ios_arrow_forward, color:Color.orange), forState:UIControlStateNormal
      @moreView.addTarget self, action: 'open_place_action', forControlEvents: UIControlEventTouchDown
      @moreView.setHidden true
      @cardView.addSubview @moreView
    end

    # Name
    @nameStr = @place['name'].nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Medium(19),
      UITextAttributeTextColor => Color.blue
    })
    @name = @nameStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    height += @name.size.height

    # Address
    if !@checkinScreen
      @addrStr = @place['address'].gsub(/, Portland[\,]? OR[\s0-9]*/, '').gsub(/, Portland, OR/, '').nsattributedstring({
        NSFontAttributeName => Font.Karla_Bold(17),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.dark_gray
      })
      @addr = @addrStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += 4 + @addr.size.height
    end

    # Meta
    unless @place[:distance].nil?
      units = @place[:units]
      bits = @place[:distance].to_s.split(".")
      str = ""
      if units == 'ft'
        str = bits[0]
      else
        unless bits[1].nil?
          str = bits[0]+"."+bits[1][0..2]
        end
      end
      str = str+" "+@place[:units]+" away"
      if @place[:checkins] && !@checkinScreen
        str+= ' - ' + @place[:checkins].to_s+' WDSers there now'
      end
      @metaStr = str.nsattributedstring({
        NSFontAttributeName => Font.Karla_Italic(15),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.dark_gray
      })
      @meta = @metaStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += @meta.size.height+4
    end

    if !@place[:pick].nil? && @place[:pick].length > 0 && @onPicked
      pickStr = "Picked by " + @place[:pick].to_s
      @pickStr = pickStr.nsattributedstring({
        NSFontAttributeName => Font.Karla_Bold(15),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.green
      })
      @pick = @pickStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += @pick.size.height+4
    else
      @pickStr = nil
    end

    @checkinStr = @checkinMessage.attrd({
        NSFontAttributeName => Font.Karla_Bold(15),
        UITextAttributeTextColor => Color.orange
      })
    @checkin = @checkinStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    return height
  end
  def open_place_action
    if !@place[:descr].nil? && @place[:descr].length() > 0
      @controller.open_place(@place)
    end
  end
  def nav_action
    chrome = "comgooglemaps://"
    chromeURL = NSURL.URLWithString(chrome)
    destination = @place['lat'].to_s+','+@place['lon'].to_s
    if UIApplication.sharedApplication.canOpenURL(chromeURL)
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(chrome+'?daddr='+destination+'&directionsmode=walking'))
    else
      place = MKPlacemark.alloc.initWithCoordinate(CLLocationCoordinate2DMake(@place['lat'], @place['lon']), addressDictionary: nil)
      item = MKMapItem.alloc.initWithPlacemark(place)
      item.setName(@place['name'])
      currentLocationMapItem = MKMapItem.mapItemForCurrentLocation
      launchOptions = {
        MKLaunchOptionsDirectionsModeKey => MKLaunchOptionsDirectionsModeWalking
      }
      MKMapItem.openMapsWithItems([currentLocationMapItem, item], launchOptions: launchOptions)
    end
  end
  def name_rect
    @name_top = 10
    CGRectMake(10, 10, @name.size.width, @name.size.height)
  end
  def addr_rect
    @addr_top = @name_top + @name.size.height+4
    CGRectMake(35, @addr_top, @addr.size.width, @addr.size.height)
  end
  def meta_rect
    @meta_top = @name_top + @name.size.height + 4
    unless @addr_top.nil?
      @meta_top = @addr_top + @addr.size.height + 4
    end
    CGRectMake(10, @meta_top, @meta.size.width, @meta.size.height)
  end
  def pick_rect
    if @meta.nil?
      @pick_top = @addr_top + @addr.size.height + 4
    else
      @pick_top = @meta_top + @meta.size.height + 4
    end
    CGRectMake(10, @pick_top, @pick.size.width, @pick.size.height)
  end
  def more_rect
    size = self.frame.size
    if !@addStr.nil?
      width = size.width - @addr.size.width
    else
      width = size.width - 50
    end
    x = size.width - width
    CGRectMake(x, 0, width, size.height)
  end
  def button_rect
    width = 110
    height = 30
    paddingRight = 10
    x = @size.width-width-paddingRight
    y = (@size.height/2) - (height/2)
    CGRectMake(x, y, width, height)
  end
  def checkin_action
    @checkinMessage = "Checking In"
    self.setNeedsDisplay
    @controller.do_checkin(self)
  end
  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    y = pnt.y
    x = pnt.x
    size = self.frame.size
    width = size.width
    height = size.height
    rects = {
      open_place: more_rect
    }
    if @checkinScreen
      rects = {
        checkin: button_rect
      }
    end
    rects.each do |name, rect|
      if CGRectContainsPoint(rect, pnt)
        self.send(name+'_action')
      end
    end
  end
  def drawRect(rect)
    # Init
    height = getHeight
    size = rect.size
    @size = size
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end
    unless @navView.nil?
      frame = @navView.frame
      frame.origin.x = 11
      frame.origin.y = 16+@name.size.height
      @navView.setFrame frame
      if (!@place[:descr].nil? && @place[:descr].length > 0)
        frame = @moreView.frame
        frame.origin.x = size.width - frame.size.width - 10
        frame.origin.y = (size.height/2) - (frame.size.height/2)
        @moreView.setFrame frame
        @moreView.setHidden false
      else
        @moreView.setHidden true
      end
    end
  end
end

class PlaceCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors
    orange = Color.orange
    white = Color.white
    tan = Color.tan

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius:0.0)
    white.setFill
    bgPath.fill

    linePath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, rect.size.height-1, rect.size.width, 1), cornerRadius:0.0)
    tan.setFill
    linePath.fill

    if @cell.checkinScreen
      bRect = @cell.button_rect
      btnPath = UIBezierPath.bezierPathWithRoundedRect(bRect, cornerRadius:3.0)
      tan.setFill
      btnPath.fill
      x = bRect.origin.x + (bRect.size.width/2) - @cell.checkin.size.width/2
      y = bRect.origin.y + (bRect.size.height/2) - @cell.checkin.size.height/2
      @cell.checkinStr.drawAtPoint(CGPointMake(x,y))
    end

    @cell.nameStr.drawInRect(@cell.name_rect)
    unless @cell.checkinScreen
      @cell.addrStr.drawInRect(@cell.addr_rect)
    end
    unless @cell.metaStr.nil?
      @cell.metaStr.drawInRect(@cell.meta_rect)
    end
    unless @cell.pickStr.nil?
      @cell.pickStr.drawInRect(@cell.pick_rect)
    end
  end
end