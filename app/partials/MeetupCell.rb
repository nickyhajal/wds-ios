class MeetupCell < PM::TableViewCell
  attr_accessor :event, :layout
  def initWithStyle(style, reuseIdentifier:id)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def getHeight
    @whatStr = @event['what'].nsattributedstring({
      NSFontAttributeName => UIFont.fontWithName("Vitesse-Medium", size:18.0),
      UITextAttributeTextColor => "#0A72B0".uicolor
    })
    @whoStr = @event['who'].nsattributedstring({
      NSFontAttributeName => UIFont.fontWithName("Karla", size:14.0),
      UITextAttributeTextColor => "#21170A".uicolor
    })
    size = self.frame.size
    size.width = size.width - 6 - 26
    size.height = Float::MAX
    @what = @whatStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @who = @whoStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height = 10 + @what.size.height.ceil + 15 + @who.size.height.ceil + 20 + 40
    return height
  end

  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    y = pnt.y
    x = pnt.x
    size = self.frame.size
    width = size.width
    height = size.height
    if y > height - 46
      if x < width / 2
        NSLog 'rsvp'
      else
        NSLog 'details'
      end
    end
  end

  ## Draw the TableCell
  def drawRect(rect)

    # Init
    getHeight
    size = rect.size

    # Colors
    bg = "#F2F2EA".uicolor
    btnBg = "#FDFDF8".uicolor
    cardBg = "#ffffff".uicolor
    lineBg = "#E8E8DE".uicolor

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, size.width, size.height), cornerRadius:0.0)
    bg.setFill
    bgPath.fill

    # Card
    cardBg.setFill
    cardRect = CGRectMake(3, 0, size.width-6, size.height-4)
    cardW = cardRect.size.width
    cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
    cardPath.fill

    # Buttons
    btnBg.setFill
    btnPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, size.height-40-4, size.width, 40), cornerRadius:0.0)
    btnPath.fill

    # Lines
    lineBg.setFill
    line1Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, size.height-40-4, size.width, 1), cornerRadius:0.0)
    line1Path.fill
    line2Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(2.5+cardW/2, size.height-40-4, 1, 40), cornerRadius:0.0)
    line2Path.fill

    # Strings
    rsvpStr = "RSVP".nsattributedstring({
      NSFontAttributeName => UIFont.fontWithName("Karla-Bold", size:15.0),
      UITextAttributeTextColor => "#EB9622".uicolor
    })
    rsvpBox = rsvpStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    detailsStr = "More Details".nsattributedstring({
      NSFontAttributeName => UIFont.fontWithName("Karla-Bold", size:15.0),
      UITextAttributeTextColor => "#EB9622".uicolor
    })
    detailsBox = detailsStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    rsvpStr.drawAtPoint(CGPointMake(cardW/4-rsvpBox.size.width/2,cardRect.size.height-28))
    detailsStr.drawAtPoint(CGPointMake(detailsBox.size.width/2+cardW/2,cardRect.size.height-28))
    @whatStr.drawInRect(CGRectMake(13,10,@what.size.width, @what.size.height))
    @whoStr.drawInRect(CGRectMake(13,15+@what.size.height,@who.size.width, @who.size.height))
  end
end