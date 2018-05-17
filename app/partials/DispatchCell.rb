class DispatchCell < PM::TableViewCell
  attr_accessor :item, :layout, :width, :controller, :type, :inx, :table, :showPhoto
  attr_reader :authorStr, :timeStr, :likeStr, :commentStr
  def will_display
    self.setNeedsDisplay
  end
  def shouldShowPhoto
    @showPhoto == 0
  end
  def initWithStyle(style, reuseIdentifier:id)
    @_item = false
    @type = "item"
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
    @avatar.setImageWithURL @item.author.pic.nsurl, placeholderImage:"default-avatar.png".uiimage
    unless @cardView.nil?
      @cardView.addSubview(@avatar)
    end
  end
  def prepareText
    @event = false
    size = self.frame.size
    size.width = @width - 32
    size.height = Float::MAX
    if @contentView.nil?
      @cardView = DispatchCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @cardView.cell = self
      @contentView = UITextView.alloc.initWithFrame([[4,pad_top(45)], [size.width+16,0]]) if @contentView.nil?
      @contentView.setTextColor Color.dark_gray_blue
      @contentView.setFont Font.Karla(15)

      # TODO: Intercept this link so we can auto open events and profiles
      # http://stackoverflow.com/questions/2543967/how-to-intercept-click-on-link-in-uitextview
      @contentView.dataDetectorTypes = UIDataDetectorTypeLink
      @contentView.setEditable false
      @contentView.setTintColor Color.orange
      @contentView.scrollEnabled = false
      self.addSubview @cardView
      @cardView.addSubview @contentView
    end
    if @mediaView.nil?
      @mediaView = UIImageView.alloc.initWithFrame([[0,0],[imgSize,imgSize]])
      @mediaView.contentMode = UIViewContentModeScaleAspectFill
      @mediaView.setHidden true
      @mediaView.layer.masksToBounds = true
      self.addSubview @mediaView
    end
    updateImages
    @contentStr = @item.content.nsattributedstring({
      NSFontAttributeName => Font.Karla(15),
      UITextAttributeTextColor => Color.dark_gray_blue
    })
    @contentView.setAttributedText @contentStr
    @content = @contentStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    @contentView.setFrame([[4,pad_top(48)], [@content.size.width+16,@content.size.height+36]])
    @authorStr = @item.author.full_name.nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Bold(15),
      UITextAttributeTextColor => Color.orange
    })
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    hours = (NSDate.new.utc_offset / 1.hour)
    created_at = formatter.dateFromString(@item.created_at).delta(hours:hours)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    @timeStr = Assets.relativeTime(created_at).nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(14),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.orangish_gray
    })
    makeChannelStr
    makeLikeStr
    makeCommentStr
    if @item.mediaUrl && shouldShowPhoto
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
  def makeChannelStr
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    type = @item.channel_type
    channel_str = ' - '
    if type == 'global' || type == 'twitter'
      channel_str += type
    elsif type == 'interest'
      inst = Interests.interestById(@item.channel_id)
      if inst.nil?
        channel_str += 'interest'
      else
        channel_str += inst.interest
      end
    elsif EventTypes.types.include?(type)
      events = Assets.get("events")
      if events
        events.each do |event|
          if event[:event_id] == @item.channel_id
            @event = Event.new(event)
            break
          end
        end
      end
      if @event
        channel_str += EventTypes.byId(@event.type)[:single]+': '+@event.what
      else
        channel_str += ''
      end
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
    if !@specialView.nil?
      @specialView.on_tap(x, y)
    else
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
    if @controller.respond_to?('open_event')
      @controller.open_event(@event) if @event
    end
  end
  def pad_top(val)
    val + @item.top_padding
  end

  ## Draw the TableCell
  def drawRect(rect)

    # Init
    if @type.nil?
      @type = "item"
    end

    if @type == 'item'
      prepareText
      unless @specialView.nil?
        @specialView.removeFromSuperview
        @specialView = nil
      end
      unless @cardView.nil?
        @cardView.setFrame(rect)
        @cardView.setNeedsDisplay
        @cardView.setHidden false
      end
    else
      unless @cardView.nil?
        @cardView.setHidden true
      end
      if @type == 'tckt'
        cellClass = PreOrderCell
      elsif @type == 'post-tckt'
        cellClass = PostOrderCell
      elsif @type == 'update'
        cellClass = UpdateCell
      elsif @type == 'attendee-stories'
        cellClass = AtnStoryCell
      end
      if !@specialView.nil? and @specialView.class.to_s != cellClass.to_s
        @specialView.removeFromSuperview
        @specialView = nil
        needsAdd = true
      end
      if @specialView.nil?
        @specialView = cellClass.alloc.initWithFrame(rect)
      end
      unless @item.state.nil?
        @specialView.setState @item.state
      end
      if @specialView.superview.nil?
        self.addSubview @specialView
      end
      @specialView.cell = self
      @specialView.setFrame(rect)
      @specialView.setNeedsDisplay
    end
  end
end

class DispatchCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    rect.size.width = @cell.width
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
    cardRect = CGRectMake(3, @cell.pad_top(0), size.width-6, size.height-4-@cell.item.top_padding)
    cardW = cardRect.size.width
    cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
    cardPath.fill
    @cell.authorStr.drawAtPoint(@cell.authorRect.origin)
    @cell.timeStr.drawInRect(@cell.timeRect)
    @cell.likeStr.drawAtPoint(@cell.likeRect.origin)
    @cell.commentStr.drawAtPoint(@cell.commentRect.origin)
  end
end