class DispatchCell < PM::TableViewCell
  attr_accessor :item, :layout, :width, :controller
  def will_display
    updateImages
    self.setNeedsDisplay
  end
  def initWithStyle(style, reuseIdentifier:id)
    @_item = false
    @currentStr = ''
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def updateImages
    unless @avatar.nil?
      @avatar.removeFromSuperview
      @avatar = nil
    end
    @avatar = UIImageView.alloc.initWithFrame(avatarRect)
    @avatar.contentMode = UIViewContentModeScaleAspectFill
    path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, avatarRect.size.width, avatarRect.size.height), cornerRadius:0)
    shapeLayer = CAShapeLayer.layer
    shapeLayer.path = path.CGPath
    @avatar.layer.mask = shapeLayer
    @avatar.setImageWithURL @item.author.pic, placeholderImage:"default-avatar.png".uiimage
    self.addSubview(@avatar)
  end
  def prepareText
    @event = false
    size = self.frame.size
    size.width = @width - 32
    size.height = Float::MAX
    if @contentView.nil?
      @contentView = UITextView.alloc.initWithFrame([[4,pad_top(45)], [size.width+16,0]]) if @contentView.nil?
      @contentView.setTextColor Color.coffee
      @contentView.setFont Font.Karla(15)
      @contentView.dataDetectorTypes = UIDataDetectorTypeLink
      @contentView.setEditable false
      @contentView.setTintColor Color.orange
      @contentView.scrollEnabled = false
      self.addSubview @contentView
    end
    @contentStr = @item.content.nsattributedstring({
      NSFontAttributeName => Font.Karla(15),
      UITextAttributeTextColor => Color.coffee
    })
    @contentView.setAttributedText @contentStr
    @content = @contentStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @contentView.setFrame([[4,pad_top(45)], [@content.size.width+16,@content.size.height+16]])
    @authorStr = @item.author.full_name.nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Bold(15),
      UITextAttributeTextColor => Color.orange
    })
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    hours = (NSDate.new.utc_offset / 1.hour) - 1
    created_at = formatter.dateFromString(@item.created_at).delta(hours:hours)
    puts created_at
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    @timeStr = SORelativeDateTransformer.registeredTransformer.transformedValue(created_at).nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(14),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.orangish_gray
    })
    makeChannelStr
    makeLikeStr
    makeCommentStr
  end
  def makeChannelStr
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    type = @item.channel_type
    channel_str = ' - '
    if type == 'global' || type == 'twitter'
      channel_str += type
    elsif type == 'interest'
      channel_str += Interests.interestById(@item.channel_id).interest
    elsif type == 'meetup'
      events = Assets.get("events")
      events.each do |event|
        if event[:event_id] == @item.channel_id
          @event = Event.new(event)
          break
        end
      end
      channel_str += 'Meetup: '+@event.what
    end
    @channelStr = channel_str.attrd({
      NSFontAttributeName => Font.Karla_Italic(14),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.orangish_gray
    })
    @timeStr = @timeStr + @channelStr
    @timeStr.attrd({
      NSParagraphStyleAttributeName => pgraph
    })
  end
  def makeLikeStr
    num_likes = @item.num_likes.to_i
    @likeStr = ''
    if num_likes > 0
      if num_likes == 1
        @likeStr = num_likes.to_s+' Like'
      else
        @likeStr = num_likes.to_s+' Likes'
      end
      @likeStr += ' | '
    end
    @likeStr = @likeStr.attrd({
      NSFontAttributeName => Font.Vitesse_Medium(13),
      UITextAttributeTextColor => Color.orangish_gray
    })
    doLikeStr = 'Like'
    if Me.likesFeedItem(@item.feed_id)
      doLikeStr = 'Liked!'
    end
    doLikeStr = doLikeStr.attrd({
      NSFontAttributeName => Font.Karla_Bold(14),
      UITextAttributeTextColor => Color.orange
    })
    @likeStr = @likeStr + doLikeStr
  end
  def makeCommentStr
    num_comments = @item.num_comments.to_i
    if num_comments > 1
      str = num_comments.to_s+' Comments'
    elsif num_comments > 0
      str = '1 Comment'
    else
      str = 'Comment'
    end
    str = str.attrd({
      NSFontAttributeName => Font.Karla_Bold(14),
      UITextAttributeTextColor => Color.orange
    })
    @commentStr = str
  end
  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    y = pnt.y
    x = pnt.x
    size = self.frame.size
    width = size.width
    height = size.height
    rects = {
      like: likeRect,
      comment: commentRect,
      author: authorRect,
      channel: timeRect,
      avatar: avatarRect
    }
    rects.each do |name, rect|
      if CGRectContainsPoint(rect, pnt)
        self.send(name+'_action')
      end
    end
  end
  def like_action
    Me.toggleLike @item.feed_id do |num_likes|
      @item.num_likes = num_likes
      self.setNeedsDisplay
    end
  end
  def likeRect
    CGRectMake(11, self.frame.size.height-28, @likeStr.size.width, @likeStr.size.height)
  end
  def comment_action
    @controller.open_dispatch @item
  end
  def commentRect
    CGRectMake(self.frame.size.width - @commentStr.size.width - 11, self.frame.size.height - 28, @commentStr.size.width, @commentStr.size.height)
  end
  def author_action
    @controller.open_profile @item.user_id
  end
  def authorRect
    CGRectMake(58, pad_top(8), @authorStr.size.width, @authorStr.size.height)
  end
  def avatar_action
    @controller.open_profile @item.user_id
  end
  def avatarRect
    CGRectMake(10, pad_top(8), 38, 38)
  end
  def timeRect
    CGRectMake(58, pad_top(25), self.frame.size.width-80, 50)
  end
  def channel_action
    $APP.open_event(@event, "dispatch") if @event
  end

  def pad_top(val)
    val + @item.top_padding
  end

  ## Draw the TableCell
  def drawRect(rect)
    # Init
    prepareText
    rect.size.width = @width
    size = rect.size
    textSize = CGSizeMake(size.width - 32, Float::MAX)
    # Colors
    bg = "#F2F2EA".uicolor
    btnBg = "#FDFDF8".uicolor
    cardBg = Color.white
    lineBg = "#E8E8DE".uicolor

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, size.width, size.height), cornerRadius:0.0)
    bg.setFill
    bgPath.fill

    # Card
    cardBg.setFill
    cardRect = CGRectMake(3, pad_top(0), size.width-6, size.height-4-item.top_padding)
    cardW = cardRect.size.width
    cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
    cardPath.fill
    @authorStr.drawAtPoint(authorRect.origin)
    @timeStr.drawInRect(timeRect)
    @likeStr.drawAtPoint(likeRect.origin)
    @commentStr.drawAtPoint(commentRect.origin)
  end

end