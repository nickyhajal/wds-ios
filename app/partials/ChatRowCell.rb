class ChatRowCell < PM::TableViewCell
  attr_accessor :chat, :width, :controller, :chatStr
  def initWithStyle(style, reuseIdentifier: id)
    @avW = 48
    @avP = 6
    @padding = 8
    @avGutter = @avW + @avP + @padding
    on_tap do
      @controller.open_chat_action(@chat)
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
    av_url = 'https://avatar.wds.fm/' + @chat[:av_id].to_s + '?width=96'
    @avatar.setImageWithURL av_url, placeholderImage: 'default-avatar.png'.uiimage
  end

  def getHeight
    if @cardView.nil?
      @cardView = ChatRowCellInnerView.alloc.initWithFrame([[0, 0], [frame.size.width, frame.size.height]])
      @cardView.cell = self
      addSubview(@cardView)
    end
    size = frame.size
    size.width = @width - 36
    size.height = Float::MAX
    height = @padding * 2 + 2 # 3+15+15 # Top and bottom padding
    text = ''
    if !@chat[:last_msg].nil? && !@chat[:last_msg].empty?
      text = "\n" + @chat[:last_msg]
    end
    @withStr = @chat[:with].attrd(NSFontAttributeName => Font.Vitesse_Bold(15),
                                  UITextAttributeTextColor => Color.dark_gray)
    @chatStr = text.attrd(NSFontAttributeName => Font.Karla(15),
                          UITextAttributeTextColor => Color.dark_gray)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    pgraph.lineSpacing = 2.5
    if @chat[:last_msg_stamp].to_i < 1
      relTime = "\n\t"
    else
      formatter = NSDateFormatter.alloc.init
      formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      hours = (NSDate.new.utc_offset / 1.hour)
      created_at = NSDate.dateWithTimeIntervalSince1970(@chat[:last_msg_stamp].to_i / 1000)
      # created_at = formatter.dateFromString(@chat[:last_msg_stamp]).delta(hours:hours)
      relTime = "\n" + SORelativeDateTransformer.registeredTransformer.transformedValue(created_at)
    end
    timeStr = relTime.nsattributedstring(NSFontAttributeName => Font.Karla_Italic(14),
                                         NSParagraphStyleAttributeName => pgraph,
                                         UITextAttributeTextColor => Color.dark_gray(0.7))
    @chatStr = @withStr + @chatStr + timeStr
    @chatBox = @chatStr.boundingRectWithSize(contentRect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height += @chatBox.size.height
    height
  end

  def contentRect
    CGRectMake(@avGutter, @padding - 2, frame.size.width - @avGutter - (@padding * 3), Float::MAX)
  end

  def avatarRect
    CGRectMake(@avP + 1, @avP, @avW, @avW)
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

class ChatRowCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors
    chat = @cell.chat
    if chat[:read]
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

    @cell.chatStr.drawInRect(@cell.contentRect)
  end
end
