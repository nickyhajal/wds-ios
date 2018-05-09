class NotificationCell < PM::TableViewCell
  attr_accessor :notn, :width, :controller, :notnStr
  def initWithStyle(style, reuseIdentifier: id)
    @avW = 40
    @avP = 8
    @padding = 8
    @avGutter = @avW + @avP + @padding
    @botP = 4
    on_tap do
      @controller.open_notification_action(@notn)
    end
    super
  end

  def will_display
    setNeedsDisplay
  end

  def updateAvatar
    if @avatar.nil?
      @avatar = UIImageView.alloc.initWithFrame(avatarRect)
      @avatar.contentMode = UIViewContentModeScaleAspectFill
      path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, avatarRect.size.width, avatarRect.size.height), cornerRadius: 0.0)
      shapeLayer = CAShapeLayer.layer
      shapeLayer.path = path.CGPath
      @cardView.addSubview @avatar
      @avatar.layer.mask = shapeLayer
    end
    av_url = 'https://avatar.wds.fm/' + @notn.from[:user_id].to_s + '?width=78'
    @avatar.setImageWithURL av_url, placeholderImage: 'default-avatar.png'.uiimage
  end

  def getHeight
    if @cardView.nil?
      @cardView = NotificationCellInnerView.alloc.initWithFrame([[0, 0], [frame.size.width, frame.size.height]])
      @cardView.cell = self
      addSubview(@cardView)
    end
    size = frame.size
    size.width = @width - 36
    size.height = Float::MAX
    height = @padding * 2 # 3+15+15 # Top and bottom padding
    text = ''
    text = @notn.text if !@notn.text.nil? && !@notn.text.empty?
    @notnStr = text.attrd(NSFontAttributeName => Font.Karla(16),
                          UITextAttributeTextColor => Color.dark_gray)
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    hours = (NSDate.new.utc_offset / 1.hour)
    created_at = formatter.dateFromString(@notn.created_at).delta(hours: hours)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    pgraph.lineSpacing = 3
    relTime = "\n" + SORelativeDateTransformer.registeredTransformer.transformedValue(created_at)
    timeStr = relTime.nsattributedstring(NSFontAttributeName => Font.Karla_Italic(14),
                                         NSParagraphStyleAttributeName => pgraph,
                                         UITextAttributeTextColor => Color.dark_gray(0.7))
    @notnStr += timeStr
    @notnBox = @notnStr .boundingRectWithSize(notnRect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height += @notnBox.size.height
    height += @botP
    height
  end

  def notnRect
    CGRectMake(@avGutter, @padding - 3, frame.size.width - @avGutter - (@padding * 3), Float::MAX)
  end

  def avatarRect
    CGRectMake(@avP, @avP - 1, @avW, @avW)
  end

  def drawRect(rect)
    # Init
    height = getHeight
    updateAvatar
    size = rect.size
    @size = size
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end
  end
end

class NotificationCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors

    if @cell.notn.clicked.to_i > 0
      bgC = '#FFFFF5'.uicolor
      lineC = '#EDEEDC'.uicolor
    else
      bgC = '#FCFFCA'.uicolor
      lineC = '#EDEEDC'.uicolor
    end
    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius: 0.0)
    lineC.setFill
    bgPath.fill

    cardPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height - 1), cornerRadius: 0.0)
    bgC.setFill
    cardPath.fill

    @cell.notnStr.drawInRect(@cell.notnRect)
  end
end
