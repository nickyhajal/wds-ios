class EventHostView < UIView
  attr_accessor :controller
  def initWithFrame(frame)
    @event = false
    super
  end
  def setEvent(event)
    @event = event
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
    count = 0
    if @event.hosts[count].user_id.to_s != '10124'
      @controller.open_profile(@event.hosts[count].user_id)
    end
    # @btns.each do |btn|
    #   #if btn == sender
    #     $APP.open_profile(@event.hosts[count])
    #   #end
    #   count += 1
    # end
  end
end