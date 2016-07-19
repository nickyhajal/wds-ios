class EventCell < PM::TableViewCell
  attr_accessor :event, :layout, :width, :controller, :because, :becauseStr, :who, :whoStr, :what, :whatStr, :isAttending, :isFull
  def initWithStyle(style, reuseIdentifier:id)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def will_display
    self.setNeedsDisplay
  end
  def getHeight
    if @cardView.nil?
      @cardView = EventCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @cardView.cell = self
      self.addSubview(@cardView)
    end
    @isFull = @event.isFull
    @isAttending = Me.isAttendingEvent(@event)
    @opacity = !@isAttending && @isFull ? 0.5 : 1.0
    what = @event.what.sub(" - AM", "")
    what = what.sub(" - PM", "")
    @whatStr = what.nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Medium(18),
      UITextAttributeTextColor => "#0A72B0".uicolor(@opacity)
    })
    whoStr = @event.who
    if whoStr[0].nil? || @event.type == 'academy'
      whoStr = @event.descr
      if whoStr.length > 150
        whoStr = whoStr[0..150]+'...'
      end
    else
      whoStr = ('A '+EventTypes.byId(@event.type)[:single].downcase+' for ')+(whoStr[0].downcase + whoStr[1..-1])
    end
    @whoStr = whoStr.nsattributedstring({
      NSFontAttributeName => Font.Karla(14),
      UITextAttributeTextColor => "#21170A".uicolor(@opacity)
    })
    if @event.type == 'meetup' and !@event.format.nil?
      format = @event.format.gsub(/(\w+)/) { |s| s.capitalize }
      @whoStr = (format+": ").attrd({
        NSFontAttributeName => Font.Karla_Bold(14),
        UITextAttributeTextColor => "#21170A".uicolor(@opacity)
      })+@whoStr
    end
    size = self.frame.size
    size.width = @width - 6 - 26
    size.height = Float::MAX
    @because = false
    @becauseStr = false
    @what = @whatStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @who = @whoStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height = 10 + @what.size.height.ceil + 15 + @who.size.height.ceil + 20 + 30
    unless @event.becauseStr.nil?
      @becauseStr = ("Because you\'re interested in "+@event.becauseStr).nsattributedstring({
        NSFontAttributeName => Font.Karla_Italic(14),
        UITextAttributeTextColor => Color.dark_gray
      })
      @because = @becauseStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += @because.size.height.ceil+6
    end
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
        event = @event.clone
        event.isAttending = @isAttending
        if !@isAttending || @event.type != 'academy'
          @controller.open_confirm event
        end
      else
        @controller.open_event @event
      end
    end
    if y > 10 && y < @what.size.height+10
      @controller.open_event @event
    end
  end

  ## Draw the TableCell
  def drawRect(rect)

    # Init
    getHeight
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end

  end
end

class EventCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    rect.size.width = @cell.width
    size = rect.size
    textSize = CGSizeMake(size.width - 32, Float::MAX)
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
    btnPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, size.height-40-4, size.width-6, 40), cornerRadius:0.0)
    btnPath.fill

    # Lines
    lineBg.setFill
    line1Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, size.height-40-4, size.width-6, 1), cornerRadius:0.0)
    line1Path.fill
    line2Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(2.5+cardW/2, size.height-40-4, 1, 40), cornerRadius:0.0)
    line2Path.fill

    # Strings
    if @cell.isAttending
      rsvpStr = 'Cancel RSVP'
      if @cell.event.type == 'academy'
        rsvpStr = "You're Attending!"
      end
      rsvpColor = '#BF8888'
    else
      if @cell.isFull
        rsvpStr = 'Event Full'
        rsvpColor = '#D8D8D4'
      else
        rsvpStr = 'RSVP'
      if @cell.event.type == 'academy'
        rsvpStr = "Attend"
      end
        rsvpColor = '#EB9622'
      end
      # if @cell.event.type == 'meetup'
      #   imgs = {'discover' => 'bulb', 'experience' => 'map', 'network' => 'shake'}
      #   unless @cell.event.format.nil?
      #     if @img.nil?
      #       width = 32
      #       height = width * (0.9655)
      #       x = rect.size.width-width-3
      #       y = 3
      #       imgRect = [[x, y], [width, height]]
      #       @img = UIImageView.alloc.initWithFrame(imgRect)
      #       @img.contentMode = UIViewContentModeScaleAspectFill
      #       self.addSubview @img
      #     end
      #     @img.setImage(UIImage.imageNamed(imgs[@cell.event.format]))
      #   end
      # end
    end
    rsvpStr = rsvpStr.nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(15),
      UITextAttributeTextColor => rsvpColor.uicolor
    })
    detailsStr = "More Details".nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(15),
      UITextAttributeTextColor => "#EB9622".uicolor
    })
    rsvpBox = rsvpStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    detailsBox = detailsStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @cell.whatStr.boundingRectWithSize(textSize, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @cell.whoStr.boundingRectWithSize(textSize, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    rsvpStr.drawAtPoint(CGPointMake(cardW/4-rsvpBox.size.width/2,cardRect.size.height-28))
    detailsStr.drawAtPoint(CGPointMake(detailsBox.size.width/2+cardW/2,cardRect.size.height-28))
    @cell.whatStr.drawInRect(CGRectMake(13,10,textSize.width, @cell.what.size.height))
    @cell.whoStr.drawInRect(CGRectMake(13,15+@cell.what.size.height,textSize.width, @cell.who.size.height+60))
    if @cell.becauseStr
      @cell.becauseStr.drawInRect(CGRectMake(13,15+@cell.what.size.height+5+@cell.who.size.height,textSize.width, @cell.because.size.height+60))
    end
  end
end