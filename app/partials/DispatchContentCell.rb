class DispatchContentCell < PM::TableViewCell
  attr_accessor :item, :layout, :width, :top_padding, :type, :num_comments, :controller, :timeStr, :authorStr, :type
  def will_display
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
    if @avatar.nil?
      @avatar = UIImageView.alloc.initWithFrame(avatarRect)
      @avatar.contentMode = UIViewContentModeScaleAspectFill
      path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, avatarRect.size.width, avatarRect.size.height), cornerRadius:0)
      shapeLayer = CAShapeLayer.layer
      shapeLayer.path = path.CGPath
      @avatar.layer.mask = shapeLayer
    end
    if @item.respond_to?('author') && item.author.respond_to?('pic') && @item.author.pic.length > 0
      @avatar.setImageWithURL @item.author.pic.nsurl, placeholderImage:"default-avatar.png".uiimage
      @cardView.addSubview(@avatar)
    else
      @avatar.removeFromSuperview
      @avatar = nil
    end
    if @mediaView.nil?
      @mediaView = UIImageView.alloc.initWithFrame([[0,0],[imgSize,imgSize]])
      @mediaView.contentMode = UIViewContentModeScaleAspectFill
      @mediaView.setHidden true
      @mediaView.layer.masksToBounds = true
      self.addSubview @mediaView
    end
  end
  def prepareText
    author = false
    date = false
    if @cardView.nil?
      @cardView = DispatchContentCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @cardView.cell = self
      self.addSubview @cardView
    end
    updateImages
    if @type == 'dispatch'
      makeAuthorStr @item.author
      makeContentStr @item.content
      makeTimeStr @item.createdTime, @item.channel_type
    elsif @type == 'comment'
      makeAuthorStr @item.author
      makeContentStr @item.comment
      makeTimeStr @item.createdTime
    else
      @authorStr = nil
      @timeStr = nil
      @likeStr = nil
      @commentStr = nil
      makeContentStr item, true
    end
  end
  def makeContentStr(content, msg = false)
    size = self.frame.size
    size.width = @width - 6 - 26
    size.height = Float::MAX
    if @contentView.nil?
      @contentView = UITextView.alloc.initWithFrame([[4,58], [size.width+16,0]]) if @contentView.nil?
      @contentView.setTextColor Color.dark_gray_blue
      @contentView.setFont Font.Karla(15)
      @contentView.dataDetectorTypes = UIDataDetectorTypeLink
      @contentView.setEditable false
      @contentView.setTintColor Color.orange
      @contentView.scrollEnabled = false
      @cardView.addSubview @contentView
    end
    @contentStr = content.nsattributedstring({
      NSFontAttributeName => msg ? Font.Vitesse_Medium(14) : Font.Karla(15),
      UITextAttributeTextColor => msg ? Color.orangish_gray : Color.dark_gray_blue
    })
    @contentView.setAttributedText @contentStr
    framePadding = @type == 'dispatch' ? 20 : 16
    @content = @contentStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @contentView.setFrame([[4,48], [@content.size.width+16,@content.size.height+framePadding+20]])
    if @item.class.to_s.include?('DispatchItem') && @item.mediaUrl
      avF = @avatar.frame
      baseFrame = @contentView.frame
      y = baseFrame.size.height+baseFrame.origin.y+6
      avY = avF.size.height+avF.origin.y+6
      y = avY if avY > y
      @mediaView.setFrame([[2, y], [imgSize,(imgSize*0.75)]])
      @mediaView.setImageWithURL(@item.mediaUrl.nsurl, placeholderImage:UIImage.imageNamed("gray_dots.png"))
      @mediaView.setHidden false
    else
      @mediaView.setHidden true
    end
  end
  def imgSize
    UIScreen.mainScreen.bounds.size.width - 4
  end
  def makeAuthorStr(author)
   @authorStr = @item.author.full_name.nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Bold(15),
      UITextAttributeTextColor => Color.orange
    })
  end
  def makeTimeStr(time, channel = false)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    @timeStr = time.nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(14),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.orangish_gray
    })
    if channel
      makeChannelStr channel
    end
  end
  def makeChannelStr(type)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    channel_str = ' - '
    if type == 'global' || type == 'twitter'
      channel_str += type
    elsif type == 'interest'
      inst = Interests.interestById(@item.channel_id)
      if inst.nil?
        channel_str = 'interest'
      else
        channel_str += inst.interest
      end
    elsif EventTypes.types.include?(type)
      events = Assets.get("events")
      events.each do |event|
        if event[:event_id] == @item.channel_id
          @event = Event.new(event)
          break
        end
      end
      if @event.nil?
        channel_str = EventTypes.byId(@event.type)[:single].downcase
      else
        channel_str += EventTypes.byId(@event.type)[:single]+': '+@event.what
      end
    end
    @channelStr = channel_str.attrd({
        NSFontAttributeName => Font.Karla_Italic(14),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.orangish_gray
    })
    @timeStr = @timeStr + @channelStr
    @timeStr = @timeStr.attrd({
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
      avatar: avatarRect,
      author: authorRect
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
    puts 'like'
  end
  def commentRect
    CGRectMake(self.frame.size.width - @commentStr.size.width - 11, self.frame.size.height - 28 + @top_padding, @commentStr.size.width, @commentStr.size.height)
  end
  def author_action
    @controller.open_profile @item.user_id
  end
  def authorRect
    CGRectMake(58, 8+@top_padding, @authorStr.size.width, @authorStr.size.height)
  end
  def avatar_action
    @controller.open_profile @item.user_id
  end
  def avatarRect
    CGRectMake(10, 8+@top_padding, 38, 38)
  end
  def timeRect
    CGRectMake(58, 25+@top_padding, self.frame.size.width-80, 50)
  end

  ## Draw the TableCell
  def drawRect(rect)
    # Init
    prepareText
    rect.size.width = @width
    size = rect.size
    bg = "#F2F2EA".uicolor
    cardBg = Color.white
    textSize = CGSizeMake(size.width - 32, Float::MAX)
    if @type == 'dispatch'
      @contentView.setBackgroundColor(cardBg)
    elsif @type == 'comment'
      @contentView.setBackgroundColor(bg)
    elsif @type == 'loading'
      @contentView.setBackgroundColor(bg)
    end
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end
  end

end


class DispatchContentCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors
    bg = "#F2F2EA".uicolor
    btnBg = "#FDFDF8".uicolor
    cardBg = Color.white
    lineBg = "#E8E8DE".uicolor

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, size.width, size.height+@cell.top_padding), cornerRadius:0.0)
    bg.setFill
    bgPath.fill

    # Card
    if @cell.type == 'dispatch'
      cardBg.setFill
      cardRect = CGRectMake(3, 0+@cell.top_padding, size.width-6, size.height-4-@cell.top_padding)
      cardW = cardRect.size.width
      cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
      cardPath.fill
    end
    unless @cell.authorStr.nil?
      @cell.authorStr.drawAtPoint(@cell.authorRect.origin)
    end
    unless @cell.timeStr.nil?
      @cell.timeStr.drawInRect(@cell.timeRect)
    end
    #@likeStr.drawAtPoint(likeRect.origin)
    #@commentStr.drawAtPoint(commentRect.origin)
  end
end