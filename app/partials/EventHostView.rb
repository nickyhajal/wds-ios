class EventHostView < UIView
  attr_accessor :controller
  def initWithFrame(frame)
    @event = false
    super
  end
  def setEvent(event)
    @event = event
    @placements = []
    self.subviews.makeObjectsPerformSelector('removeFromSuperview')
    addHosts
  end
  def addHosts
    x = 58
    @lastBtn = ''
    @btns = []
    if @event.type == 'program'
      @event.hosts = [Attendee.new({ first_name: 'WDS', last_name: 'Team', user_id: '10124'})]
    end
    @event.hosts.each do |host|
      @lastBtn = AttendeeButton.alloc.initWithFrame([[x, 0], [0,0]])
      @lastBtn.setAttendee host
      @lastBtn.addTarget self, action: 'touch_action:', forControlEvents:UIControlEventTouchDown
      self.addSubview @lastBtn
      @placements << x
      x += @lastBtn.frame.size.width + 4
      @btns << @lastBtn
    end
  end
  def openByX(x)
    touch_action(x)
  end
  def drawRect(rect)
    bgPath = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:0.0)
    self.backgroundColor.setFill
    bgPath.fill
    hosts = "Hosted\nBy".nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Bold(14),
      UITextAttributeTextColor => Color.gray
    })
    hosts.drawAtPoint(CGPointMake(0,6))
  end
  def touch_action
  end
  def touch_action(sender)
    inx = 0
    c = 0
    @placements.each do |x|
      if (x-58) <= sender
        inx = c
      end
      c += 1
    end
    if @event.hosts[inx].user_id.to_s != '10124'
      @controller.open_profile(@event.hosts[inx].user_id)
    end
    # @btns.each do |btn|
    #   puts btn.inspect
    #   puts sender.inspect
    #   if btn == sender
    #     @controller.open_profile(@event.hosts[count].user_id)
    #     # $APP.open_profile(@event.hosts[count])
    #   end
    #   count += 1
    # end
  end
end