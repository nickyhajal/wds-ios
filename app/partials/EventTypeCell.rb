class EventTypeCell < PM::TableViewCell
  attr_accessor :name, :layout, :width, :controller
  attr_reader :typeName, :typeImage, :typeStr, :descrStr, :arrowStr
  def will_display
    self.setNeedsDisplay
  end
  def initWithStyle(style, reuseIdentifier:id)
    @_item = false
    @currentStr = ''
    @descrs = {
      trust_issues: 'A featured event to bring WDS Attendees together',
      meetups: 'Informal hangouts and attendee-led gatherings',
      academies: 'Half-day workshops taught by alumni speakers and other experts',
      # spark_sessions: 'Open-ended conversations on specific topics',
      activities: 'Special activities to share with your fellow attendees',
      registration: 'Let us know which registration session works for you',
      # expeditions: 'Unique adventures crafted just for WDS Attendees',
    }
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def updateImages
    type = @type
    img = "tile_"+type+".jpg"
    # puts img ## i want to preload these images
    if @img.nil?
      @img = UIImageView.alloc.initWithFrame(imgRect)
      @img.contentMode = UIViewContentModeScaleAspectFill
      self.addSubview @img
    end
    if @overlay.nil?
      @overlay = UIImageView.alloc.initWithFrame(imgRect)
      @overlay.contentMode = UIViewContentModeScaleAspectFill
      @overlay.setImage(UIImage.imageNamed("faded_overlay.png"))
      self.addSubview @overlay
    end
    @img.setImage(UIImage.imageNamed(img))
  end
  def prepareText
    @type = @name.downcase.gsub ' ', '_'
    @event = false
    size = self.frame.size
    size.height = Float::MAX
    dsize = self.frame.size
    dsize.height = Float::MAX
    dsize.width = @width - (@width/3) - 20

    shadow = NSShadow.alloc.init
    shadow.shadowColor = "#000000".uicolor(0.6)
    shadow.shadowBlurRadius = 2.0;
    shadow.shadowOffset = CGSizeMake(1.0, 1.0);

    name = @name.clone
    name = 'Connect' if name == 'Activities'
    @typeStr = name.attrd({
      NSFontAttributeName => Font.Vitesse_Bold(34),
      UITextAttributeTextColor => Color.light_tan,
      NSShadowAttributeName => shadow
    })
    @arrowStr = Ion.icons[@type ==='trust_issues'? :chevron_up : :ios_arrow_forward].attrd({
      NSFontAttributeName => IonIcons.fontWithSize(@type == 'trust_issues' ? 29 : 38),
      UITextAttributeTextColor => Color.light_tan,
      NSShadowAttributeName => shadow
    })
    @typeBox = @typeStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @descrStr = @descrs[@type.to_sym].attrd({
      NSFontAttributeName => Font.Graphik_BoldItalic(15),
      UITextAttributeTextColor => Color.light_tan(0.8),
      NSShadowAttributeName => shadow
    })
    @descrBox = @descrStr.boundingRectWithSize(dsize, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
  end
  def singleTap(theEvent)
    @controller.open_event(@type)
  end
  def imgRect
    CGRectMake(0, 0, self.frame.size.width, getHeight)
  end
  def typeRect
    selfH = self.frame.size.height
    boxH = @descrBox.size.height
    top = selfH - boxH - @typeBox.size.height - 20
    CGRectMake(20, top, self.frame.size.width, @typeBox.size.height)
  end
  def descrRect
    selfH = self.frame.size.height
    boxH = @descrBox.size.height
    CGRectMake(20, selfH - boxH - 18, @width - (@width/3) - 20, boxH+20)
  end
  def arrowRect
    x = self.frame.size.width - 20 - 15 - (@type == 'trust_issues' ? 8 : 0)
    y = self.frame.size.height - 20 - 33
    CGRectMake(x, y, 240, 370)
  end
  def getHeight
    self.frame.size.width * 0.67
  end
  def prepareContent
    if @contentView.nil?
      @contentView = EventTypeCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @contentView.cell = self
      @contentView.opaque = false
      self.addSubview @contentView
    end
  end

  ## Draw the TableCell
  def drawRect(rect)
    prepareText
    updateImages
    prepareContent
    unless @contentView.nil?
      @contentView.setFrame(rect)
      @contentView.setNeedsDisplay
    end
  end
end

class EventTypeCellInnerView < UIView
  attr_accessor :cell
  def initWithFrame(frame)
    self.opaque = false;
    super
  end
  def drawRect(rect)
    rect.size.width = @cell.width
    size = rect.size
    @cell.typeStr.drawInRect(@cell.typeRect)
    @cell.descrStr.drawInRect(@cell.descrRect)
    @cell.arrowStr.drawInRect(@cell.arrowRect)
  end
end