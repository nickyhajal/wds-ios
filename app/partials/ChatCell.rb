class ChatCell < PM::TableViewCell
  attr_accessor :chat, :width, :controller, :chatStr, :authorStr, :stampStr
  def initWithStyle(style, reuseIdentifier:id)
    @avW = 38
    @avP = 4
    @botP = 28
    @avGutter = @avW + (@avP * 2)
    @cardP = 20
    @me_id = Me.atn.user_id.to_s
    super
  end
  def cardW
    @controller.layout.super_width * 0.65
  end
  def will_display
    self.setNeedsDisplay
  end
  def getHeight
    @author_id = @chat[:user_id].to_s
    if @cardView.nil?
      @cardView = ChatCellInnerView.alloc.initWithFrame([[0,0], [0,0]])
      @cardView.cell = self
      @cardView.rotate_to Math::PI, {duration: 0}
      self.addSubview(@cardView)
    end
    cardSize = self.frame.size
    cardSize.width = cardW - (@cardP * 2) - 45
    cardSize.height = Float::MAX
    height = @cardP * 2
    msg = ""
    if !@chat[:msg].nil? && @chat[:msg].length() > 0
      msg = @chat[:msg]
    end
    now = NSDate.new.timeIntervalSince1970
    created = NSDate.dateWithTimeIntervalSince1970(@chat[:created_at].to_i / 1000)
    diff = now - created.timeIntervalSince1970
    if diff < 3600
      formatter = NSDateFormatter.alloc.init
      formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      hours = (NSDate.new.utc_offset / 1.hour)
      created_at = NSDate.dateWithTimeIntervalSince1970(@chat[:created_at].to_i / 1000)
      # created_at = formatter.dateFromString(@chat[:last_msg_stamp]).delta(hours:hours)
      datetime = Assets.relativeTime(created_at)
    elsif diff < 86400
      datetime = created.string_with_format('h:mma').downcase
    else
      date = created.string_with_format('d/M/yy')
      time = created.string_with_format('h:mma').downcase
      datetime = date+' '+time
    end
    @stampStr = datetime.attrd({
      NSFontAttributeName => Font.Karla_Italic(13),
      UITextAttributeTextColor => Color.dark_gray
    })
    @authorStr = "#{@chat[:author]}".attrd({
      NSFontAttributeName => Font.Karla_Bold(13),
      UITextAttributeTextColor => Color.dark_gray
    })
    @chatStr = msg.attrd({
      NSFontAttributeName => Font.Karla(15),
      UITextAttributeTextColor => Color.dark_gray
    })
    @chatBox = @chatStr.boundingRectWithSize(cardSize, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    if @contentView.nil?
      @contentView = UITextView.alloc.initWithFrame(chatContentRect) if @contentView.nil?
      @contentView.setTextColor Color.coffee
      @contentView.setFont Font.Karla(15)
      @contentView.dataDetectorTypes = UIDataDetectorTypeLink
      @contentView.setEditable false
      @contentView.setTintColor Color.orange
      @contentView.scrollEnabled = false
      @cardView.addSubview @contentView
    end
    @contentView.setAttributedText @chatStr
    cardSize.width = Float::MAX
    @stampBox = @stampStr.boundingRectWithSize(cardSize, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    frame = chatContentRect
    frame.origin.y -= 8
    frame.size.height = @chatBox.size.height+18
    @contentView.setFrame(frame)
    height += @chatBox.size.height
    height += @botP
    return height
  end
  def updateAvatar
    if @avatar.nil?
      @avatar = UIImageView.alloc.initWithFrame(avatarRect)
      @avatar.contentMode = UIViewContentModeScaleAspectFill
      path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, avatarRect.size.width, avatarRect.size.height), cornerRadius:(@avW/2))
      shapeLayer = CAShapeLayer.layer
      shapeLayer.path = path.CGPath
      @cardView.addSubview @avatar
      @avatar.layer.mask = shapeLayer
    end
    av_url = "https://avatar.wds.fm/"+@chat[:user_id].to_s+"?width=78"
    @avatar.setImageWithURL av_url.nsurl, placeholderImage:"default-avatar.png".uiimage
  end
  def isMe
    @me_id == @author_id
  end
  def cardRect
    frame = self.frame
    w = cardW
    h = @chatBox.size.height + (@cardP * 2)
    y = 0
    if isMe
      x = frame.size.width - @avGutter - w
    else
      x = @avGutter
    end
    CGRectMake(x, y, w, h)
  end
  def chatContentRect
    rect = cardRect
    rect.origin.x += @cardP
    rect.origin.y += @cardP
    rect.size.width = cardW - (@cardP * 2)
    rect.size.height = Float::MAX
    rect
  end
  def avatarRect
    frame = self.frame
    av = @avW
    y = frame.size.height - av - @avP - 11
    if isMe
      x = frame.size.width - av - @avP
    else
      x = @avP
    end
    CGRectMake(x, y, av, av)
  end
  def authorRect
    rect = cardRect
    rect.origin.y = rect.size.height + 4
    rect
  end
  def stampRect
    rect = cardRect
    rect.origin.y = rect.size.height + 4
    if isMe
      x = rect.origin.x + rect.size.width - @stampBox.size.width
      rect.origin.x = x
    else
      rect.origin.x = rect.size.width - @stampBox.size.width + @avGutter
    end
    rect
  end
  def drawRect(rect)
    tan = Color.tan

    height = getHeight
    updateAvatar
    size = rect.size
    @size = size

    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius:0.0)
    tan.setFill
    bgPath.fill


    unless @avatar.nil?
      @avatar.setFrame(avatarRect)
      @avatar.setNeedsDisplay
    end
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end

  end
end

class ChatCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors
    orange = Color.orange
    white = Color.white
    tan = Color.tan

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:0.0)
    tan.setFill
    bgPath.fill

    cardPath = UIBezierPath.bezierPathWithRoundedRect(@cell.cardRect, cornerRadius:4.0)
    white.setFill
    cardPath.fill


    # @cell.chatStr.drawInRect(@cell.chatContentRect)
    @cell.stampStr.drawInRect(@cell.stampRect)
    @cell.authorStr.drawInRect(@cell.authorRect)
  end
end
