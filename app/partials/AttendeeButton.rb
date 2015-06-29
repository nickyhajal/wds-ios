class AttendeeButton < UIButton
  def initWithFrame(frame)
    @atn = false
    super
  end
  def setAttendee(atn)
    self.subviews.makeObjectsPerformSelector('removeFromSuperview')
    @atn = atn
    attributedName(true)
    sizeToFit
    drawImg
    self.setNeedsDisplay
  end
  def attributedName(reset = false)
    if (reset)
      @name = nil
    end
    @name ||= begin 
      name = @atn.first_name+"\n"+@atn.last_name
      name = name.nsattributedstring({
        UITextAttributeFont => Font.Karla_Bold(15),
        NSForegroundColorAttributeName => Color.orange
      })
      name
    end
  end
  def sizeToFit
    width = @name.size.width
    frame = self.frame
    frame.size.width = 5 + 30 + 5 + 5 + width
    frame.size.height = 39
    self.setFrame frame
  end
  def drawImg
    @img = UIImageView.alloc.initWithFrame([[ 0, 3 ], [ 32, 32 ]])
    @img.setImageWithURL(@atn.pic.nsurl, placeholderImage:"default-avatar.png".uiimage)
    @img.layer.cornerRadius = 16.0
    @img.layer.masksToBounds = true
    self.addSubview @img
  end
  def drawRect(rect)
    light_tan = Color.tan
    orange = Color.orange
    if @atn
      bgRect = rect
      bgRect.origin.x += 10
      bgRect.size.width -= 5
      bgPath = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:0.0)
      light_tan.setFill
      bgPath.fill
      @name.drawAtPoint(CGPointMake(38,2))
    end
  end
end