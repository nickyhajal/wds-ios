class PostOrderCell < UIView
  attr_accessor :cell
  def on_tap(x, y)
    if y > self.frame.size.height - 64
      @cell.controller.post_tckt_action
    end
  end
  def setState(state)
  end
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
    cardRect = CGRectMake(3, 4, size.width-6, size.height-4-4)
    cardW = cardRect.size.width
    cardPath = UIBezierPath.bezierPathWithRoundedRect(cardRect, cornerRadius:0.0)
    cardPath.fill

    iw = rect.size.width
    ih = iw * 0.678
    if @img.nil?
      @img = UIImageView.alloc.initWithFrame(CGRectMake(3,4,iw-2,ih-8))
      # @img.contentMode = UIViewContentModeScaleAspectFill
      @img.setImage(UIImage.imageNamed("postorder"))
      self.addSubview @img
    end

    btn_bg_h = Device.is4 ? 46 : 64
    cpadding = Device.is4 ? 160 : 104
    cw = iw - cpadding
    cx = cpadding / 2
    ch = cw * 0.462
    cont_size = rect.size.height-ih - btn_bg_h
    cy = ih + ((cont_size)/2) - (ch/2) - 2
    if @cont.nil?
      @cont = UIImageView.alloc.initWithFrame(CGRectMake(cx, cy, cw, ch))
      # @img.contentMode = UIViewContentModeScaleAspectFill
      @cont.setImage(UIImage.imageNamed("postorder_content"))
      self.addSubview @cont
    end

    # Background
    btn_bg_y = rect.size.height - btn_bg_h - 0
    btn_bg_w = rect.size.width - 6
    btn_bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_bg_y, btn_bg_w, btn_bg_h), cornerRadius:0.0)
    bg.setFill
    btn_bgPath.fill

    btn_sh_h = btn_bg_h - 12
    btn_sh_y = btn_bg_y + 4
    btn_shPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_sh_y, btn_bg_w, btn_sh_h), cornerRadius:0.0)
    "#D17E1C".uicolor.setFill
    btn_shPath.fill

    btn_h = btn_sh_h - 2
    btn_y = btn_sh_y
    btn_Path = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, btn_y, btn_bg_w, btn_h), cornerRadius:0.0)
    Color.orange.setFill
    btn_Path.fill

    fontSize = Device.is4 ? 18 : 24
    @btnStr = "Sounds Good!".attrd({
      NSFontAttributeName => Font.Karla_Bold(fontSize),
      UITextAttributeTextColor => Color.light_tan
    })
    box = self.frame.size
    box.width = btn_bg_w
    box.height = Float::MAX
    btnBox = @btnStr.boundingRectWithSize(box, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    pnt = CGPointMake((btn_bg_w/2)-(btnBox.size.width/2), btn_y + ((btn_h/2)-(btnBox.size.height/2)))
    @btnStr.drawAtPoint(pnt)

  end
end