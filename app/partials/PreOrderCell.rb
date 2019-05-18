class PreOrderCell < UIView
  attr_accessor :cell, :state
  def initWithFrame(frame)
    super
  end
  def initViews
    if @openView.nil?
      @openView = PreOrderCell_Open.alloc.initWithFrame(self.frame)
      @openView.fade_out(0) if @state == 'closed'
      self.addSubview(@openView)
    end
    if @closedView.nil?
      @closedView = PreOrderCell_Closed.alloc.initWithFrame(self.frame)
      @closedView.fade_out(0) if @state == 'open'
      self.addSubview(@closedView)
    end
  end
  def on_tap(x, y)
    if @state == 'open'
      if y > self.frame.size.height - 64 - 55
        @cell.controller.tckt_purchase_action
      elsif y < 40 and x > self.frame.size.width-46
        changeState
      end
    else
      changeState
    end
  end
  def setState(state)
    if @state.nil?
      @state = state
    elsif @state != state
      changeContentState(state)
    end
  end
  def changeContentState(state)
    @state = state
    if @state == 'open'
      @closedView.fade_out
      @openView.fade_in
    else
      @closedView.fade_in
      @openView.fade_out
    end
  end
  def changeState
    if @state == 'open'
      new_state = 'closed'
      height = @cell.table.bannerHeight
    else
      new_state = 'open'
      height = @cell.table.fullHeight
    end
    @cell.table.update_cell_height(@cell.inx, height, new_state, 'preorder18')
  end
  def drawRect(rect)
    initViews
    unless @openView.nil?
      openRect = rect
      openRect.size.height = @cell.table.fullHeight
      @openView.setFrame(openRect)
      @openView.setNeedsDisplay
    end
    unless @closedView.nil?
      closedRect = rect
      closedRect.size.height = @cell.table.bannerHeight
      @closedView.setFrame(closedRect)
      @closedView.setNeedsDisplay
    end
    super
  end
end
class PreOrderCell_Closed < UIView
  attr_accessor :arrow
  def drawRect(rect)
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

    @btnStr = "🎆 Pre-order for WDS 2019 & 2020!".attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(18),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @btnStr.drawAtPoint(CGPointMake(8, 20))
    if @arrow.nil?
      @arrow = UILabel.alloc.initWithFrame(CGRectMake(self.frame.size.width-20, 8, 30, 42))
      @arrow.attributedText = Ion.icons[:ios_arrow_forward].attrd({
        NSFontAttributeName => IonIcons.fontWithSize(20),
        UITextAttributeTextColor => "#999590".uicolor
      })
      self.addSubview @arrow
    end
  end
end
class PreOrderCell_Open < UIView
  def arrowRect
    w = 24
    h = 20
    CGRectMake(self.frame.size.width-w-6, 14, w, h)
  end
  def drawRect(rect)

    pre = $STATE[:pre]
    s_soldout = pre[:single_soldout].nil? ? false : pre[:single_soldout] > 0
    d_soldout = pre[:double_soldout].nil? ? false : pre[:double_soldout] > 0

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
    cardRect = CGRectMake(3, 4, size.width-6, size.height-4-4)
    cardW = cardRect.size.width
    cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
    cardPath.fill

    iw = rect.size.width
    ih = iw * 0.4176
    # ih = iw * 0.556
    if @img.nil?
      @img = UIImageView.alloc.initWithFrame(CGRectMake(2,3,iw-4,ih-8))
      # @img.contentMode = UIViewContentModeScaleAspectFill
      @img.setImage(UIImage.imageNamed("preorder"))
      self.addSubview @img
    end
    if @shmoo.nil?
      @shmoo= UIImageView.alloc.initWithFrame(CGRectMake(iw-44,ih-30,42,71))
      # @img.contentMode = UIViewContentModeScaleAspectFill
      @shmoo.setImage(UIImage.imageNamed("green_shmoo"))
      self.addSubview @shmoo
    end

    rt_h = 55
    btn_bg_h = Device.is4 ? 46 : 64
    cpadding = Device.is4 ? 160 : 104
    cw = iw - cpadding
    cx = cpadding / 2
    ch = cw * 0.397
    cont_size = rect.size.height-ih - btn_bg_h - rt_h - 8
    cy = ih + ((cont_size)/2) - (ch/2) - 2
    # if @cont.nil?
    #   @cont = UIImageView.alloc.initWithFrame(CGRectMake(cx, cy, cw, ch))
    #   # @img.contentMode = UIViewContentModeScaleAspectFill
    #   @cont.setImage(UIImage.imageNamed("preorder_content"))
    #   self.addSubview @cont
    # end

    # Background
    btn_bg_y = rect.size.height - btn_bg_h - rt_h
    btn_use_h = rect.size.height - btn_bg_y
    btn_bg_w = rect.size.width - 6
    hi_y = ih-8
    cont_h = btn_bg_y - ih
    hi_h = cont_h * 0.6

    hi_path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(2, hi_y, iw, hi_h), cornerRadius:0.0)
    "#FFFDEF".uicolor.setFill
    hi_path.fill
    hi_line = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(2, hi_y+hi_h, iw, 1), cornerRadius:0.0)
    "#F4F4E0".uicolor.setFill
    hi_line.fill

    btn_bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_bg_y, btn_bg_w, btn_use_h), cornerRadius:0.0)
    bg.setFill
    btn_bgPath.fill

    btn_sh_h = btn_bg_h - 12
    btn_sh_y = btn_bg_y + 4
    btn_shPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_sh_y, btn_bg_w, btn_sh_h), cornerRadius:0.0)
    "#E54B2C".uicolor.setFill
    btn_shPath.fill

    btn_h = btn_sh_h - 2
    btn_y = btn_sh_y
    btn_Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_y, btn_bg_w, btn_h), cornerRadius:0.0)
    Color.orange.setFill
    btn_Path.fill
    fontSize = Device.is4 ? 18 : 24
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.alignment = NSTextAlignmentCenter
    @doubleText = "Join us for\nWDS 2019 & 2020".attrd({
      NSFontAttributeName => Font.Vitesse_Bold(fontSize),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.cyan(d_soldout ? 0.4 : 1.0)
    })
    dblBox = self.frame.size
    dblBox.width = 210
    dblBox.height = Float::MAX
    dblTxtBox = @doubleText.boundingRectWithSize(dblBox, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    dblPriceW = 200
    dblPriceH = dblPriceW*0.24
    dblTxtY = hi_y + (hi_h / 2 - ((dblTxtBox.size.height + dblPriceH) / 2))
    dblTxtPnt = CGPointMake((iw/2)-(dblTxtBox.size.width/2), dblTxtY) # ((hi_h/2)-(dblTxtBox.size.height/2)))
    @doubleText.drawInRect(CGRectMake(dblTxtPnt.x, dblTxtPnt.y, dblBox.width, dblBox.height))
    if @dblPrice.nil?
      @dblPrice = UIImageView.alloc.initWithFrame(CGRectMake(iw/2 - dblPriceW/2, dblTxtBox.size.height+dblTxtPnt.y+8, dblPriceW, dblPriceH))
      @dblPrice.contentMode = UIViewContentModeScaleAspectFill
      @dblPrice.setImage(UIImage.imageNamed("double_pricing"))
      self.addSubview @dblPrice
    end
    @dblPrice.setAlpha(d_soldout ? 0.3 : 1.0)
    if @dblSoldout.nil?
      dblSoldoutH = dblPriceH + dblTxtBox.size.height - 20
      dblSoldoutW = 2.64 * dblSoldoutH
      @dblSoldout = UIImageView.alloc.initWithFrame(CGRectMake(iw/2 - dblSoldoutW/2, dblTxtY + 13, dblSoldoutW, dblSoldoutH))
      @dblSoldout.contentMode = UIViewContentModeScaleAspectFill
      @dblSoldout.setImage(UIImage.imageNamed("sold_out"))
      self.addSubview @dblSoldout
    end
    @dblSoldout.setAlpha(d_soldout ? 0.8 : 0)
    @singleText = "OR join us for WDS 2019".attrd({
      NSFontAttributeName => Font.Vitesse_Bold(fontSize - 3),
      NSParagraphStyleAttributeName => pgraph,
      UITextAttributeTextColor => Color.cyan(s_soldout ? 0.3 : 1.0)
    })
    singleBox = self.frame.size
    singleBox.height = Float::MAX
    singleTxtBox = @singleText.boundingRectWithSize(singleBox, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    singlePriceW = 145
    singlePriceH = singlePriceW*0.252
    secondContentY = hi_y + hi_h
    secondContentH = btn_bg_y - secondContentY
    singleTxtY = (hi_y+hi_h) + (secondContentH / 2 - ((singleTxtBox.size.height + singlePriceH) / 2))
    singleTxtPnt = CGPointMake(0, singleTxtY) # ((hi_h/2)-(dblTxtBox.size.height/2)))
    @singleText.drawInRect(CGRectMake(singleTxtPnt.x, singleTxtPnt.y, singleBox.width, singleBox.height))
    if @singlePrice.nil?
      @singlePrice = UIImageView.alloc.initWithFrame(CGRectMake(iw/2 - singlePriceW/2, singleTxtBox.size.height+singleTxtPnt.y+8, singlePriceW, singlePriceH))
      @singlePrice.contentMode = UIViewContentModeScaleAspectFill
      @singlePrice.setImage(UIImage.imageNamed("single_pricing"))
      self.addSubview @singlePrice
    end
    @singlePrice.setAlpha(s_soldout ? 0.3 : 1.0)
    if @singleSoldout.nil?
      sSoldoutH = singlePriceH + singleTxtBox.size.height - 4
      sSoldoutW = 2.64 * sSoldoutH
      @singleSoldout = UIImageView.alloc.initWithFrame(CGRectMake(iw/2 - sSoldoutW/2, singleTxtY + 2, sSoldoutW, sSoldoutH))
      @singleSoldout.contentMode = UIViewContentModeScaleAspectFill
      @singleSoldout.setImage(UIImage.imageNamed("sold_out"))
      self.addSubview @singleSoldout
    end
    @singleSoldout.setAlpha(s_soldout ? 0.8 : 0)

    @btnStr = "I'm in, let's go!".attrd({
      NSFontAttributeName => Font.Vitesse_Bold(fontSize),
      UITextAttributeTextColor => Color.light_tan
    })
    box = self.frame.size
    box.width = btn_bg_w
    box.height = Float::MAX
    btnBox = @btnStr.boundingRectWithSize(box, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    pnt = CGPointMake((btn_bg_w/2)-(btnBox.size.width/2), 2+ btn_y + ((btn_h/2)-(btnBox.size.height/2)))
    @btnStr.drawAtPoint(pnt)

    if @arrow.nil?
      @arrow = UILabel.alloc.initWithFrame(arrowRect)
      shadow = NSShadow.alloc.init
      shadow.shadowColor = "#000000".uicolor(0.6)
      shadow.shadowBlurRadius = 2.0;
      shadow.shadowOffset = CGSizeMake(1.0, 1.0);
      @arrow.attributedText = "x".attrd({
        NSFontAttributeName => Font.Karla_BoldItalic(22),
        UITextAttributeTextColor => Color.light_tan,
        NSShadowAttributeName => shadow
      })
      self.addSubview @arrow
    end
    if @counter.nil?
      cntW = Device.type.to_i < 6 ? 110 : 138
      cntX = rect.size.width - cntW
      cntY = rect.size.height - rt_h
      @counter = PreorderCounterView.alloc.initWithFrame(CGRectMake(cntX, cntY, cntW, rt_h))
      @counter.backgroundColor = Color.clear
      @counter.startCount
      self.addSubview(@counter)
    end
    if @rtView.nil?
      rtX = 4
      rtW = rect.size.width - cntW - rtX
      rtY = rect.size.height - rt_h
      @rtView = PreorderRealTimeView.alloc.initWithFrame(CGRectMake(rtX, rtY, rtW, rt_h))
      @rtView.backgroundColor = Color.clear
      @rtView.startDisplay
      self.addSubview(@rtView)
    end
  end
end
class PreorderRealTimeView < UIView
  def startDisplay
    @atn = false
    @salesShown = 0
    showSale
  end
  def showSale
    if @salesShown < 4
      getSale
    else
      # We don't get a sale, so a message will be drawn
      @salesShown = 0
    end
    drawSale
    10.seconds.later do
      showSale
    end
  end
  def getSale
    if !$PRESALES.nil? and ($PRESALES[:fresh].length > 1 or $PRESALES[:used].length > 1)
      @null = false
      @salesShown += 1
      if $PRESALES[:fresh].length > 1
        @sale = $PRESALES[:fresh].pop
        $PRESALES[:used] << @sale
      else
        sales = $PRESALES[:used].shuffle
        @sale = sales[0]
      end
    else
      @null = true
    end
  end
  def getMsg
    if !$STATE.nil? and !$STATE[:pre].nil? and !$STATE[:pre][:messages].nil? and $STATE[:pre][:messages].length > 0
      msgs = $STATE[:pre][:messages].shuffle
      msg = msgs[0]
    else
      msg = "A limited quantity of tickets pre-order tickets are available. 😬"
    end
    msg
  end
  def drawSale
    if @null
      if @current.nil?
        @current = msgView
        self.addSubview(@current)
        @current.fade_in
      end
    else
      if (!@current.nil?)
        makeCurrentLeave
      end
      if @sale
        @current = saleView
        @salesShown += 1
      else
        @current = msgView
      end
      self.addSubview(@current)
      @current.fade_in
      @sale = false
    end
  end
  def makeCurrentLeave
    @old = @current
    @old.fade_out
    0.8.seconds.later do
      @old.removeFromSuperview
      @old = nil
    end
  end
  def saleView
    frame = self.frame
    frame.origin.x = 0
    frame.origin.y = 0
    shell = UIView.alloc.initWithFrame(frame)
    shell.fade_out(0)
    avatarRect = CGRectMake(4, 2, 38, 38)
    radius = 19.0
    if Device.type.to_i < 6
      radius = 16.0
      avatarRect = CGRectMake(4, 5, 32, 32)
    end
    av = UIImageView.alloc.initWithFrame(avatarRect)
    av.contentMode = UIViewContentModeScaleAspectFill
    path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, avatarRect.size.width, avatarRect.size.height), cornerRadius:radius)
    shapeLayer = CAShapeLayer.layer
    shapeLayer.path = path.CGPath
    shell.addSubview av
    av.layer.mask = shapeLayer
    av_url = "https://avatar.wds.fm/"+ @sale[:user_id].to_s+"?width=76"
    av.setImageWithURL av_url.nsurl, placeholderImage:"default-avatar.png".uiimage
    frame.origin.x += avatarRect.size.width + avatarRect.origin.x + 4
    if Device.type.to_i < 6
      frame.origin.x -= 2
    end
    frame.size.width -= frame.origin.x + 20
    frame.origin.y -= 0
    @textView = UITextView.alloc.initWithFrame(frame)
    msg = @sale[:name]+" will be at WDS 2019! "
    msg = msg.attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(13),
      UITextAttributeTextColor => Color.dark_gray
    })
    created = NSDate.dateWithTimeIntervalSince1970(@sale[:created_at].to_i / 1000)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    pgraph.lineSpacing = 3
    msg = msg.attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(13),
      UITextAttributeTextColor => Color.dark_gray
    })
    stamp = Assets.relativeTime(created).attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(11),
      UITextAttributeTextColor => Color.dark_gray(0.7)
    })
    msg = msg + stamp
    @textView.attributedText = msg
    @textView.scrollEnabled = false
    @textView.editable = false
    @textView.backgroundColor = Color.clear
    shell.addSubview(@textView)
    shell
  end
  def msgView
    frame = self.frame
    frame.origin.x = 0
    frame.origin.y = 0
    shell = UIView.alloc.initWithFrame(frame)
    shell.fade_out(0)
    frame.size.width -= 20
    frame.origin.x += 5
    frame.origin.y -= 0
    @textView = UITextView.alloc.initWithFrame(frame)
    msg = getMsg
    @textView.attributedText = msg.attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(13),
      UITextAttributeTextColor => Color.dark_gray
    })
    @textView.scrollEnabled = false
    @textView.editable = false
    @textView.backgroundColor = Color.clear
    shell.addSubview(@textView)
    shell
  end
end
class PreorderCounterView < UIView
  def startCount
    if @counting.nil? || !@counting
      self.fade_out(0)
      @counting = true
      count
    end
  end
  def count
    if !$STATE.nil? and !$STATE[:pre].nil? and !$STATE[:pre][:ends].nil?
      formatter = NSDateFormatter.alloc.init
      formatter.setDateFormat("yyyy-MM-dd HH:mm:ss")
      endsAt = formatter.dateFromString($STATE[:pre][:ends])
      unless endsAt.nil?
        now = NSDate.new.timeIntervalSince1970
        endsAt = endsAt.timeIntervalSince1970
        diff = endsAt - now
        diff = 0 if diff < 0
        hours = (diff / 3600).floor
        diff = diff.to_f % 3600
        minutes = (diff / 60).floor
        seconds = (diff % 60).floor
        @str = "#{hours}h #{minutes}m #{seconds}s"
        self.setNeedsDisplay
        self.fade_in
      end
    end
    1.0.seconds.later do
      count
    end
  end
  def drawRect(rect)
    unless @str.nil?
      fontSize = Device.type.to_i < 6 ? 16 : 20
      txtC = "#97978D".uicolor(0.7)
      @txt = @str.attrd({
        NSFontAttributeName => Font.Karla_BoldItalic(fontSize),
        UITextAttributeTextColor => txtC
      })
      box = @txt.boundingRectWithSize(rect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      x = rect.size.width - box.size.width - 8
      y = (rect.size.height / 2) - (box.size.height / 2)
      y = 8
      if Device.type.to_i <  6
        y += 3
      end
      @txt.drawAtPoint(CGPointMake(x,y+5))
      line = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 6, 2, 30), cornerRadius:0.0)
      "#D0D0C5".uicolor.setFill
      # Color.blue.setFill
      line.fill
    end
  end
end