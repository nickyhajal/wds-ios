class PopupButton < UIView
  attr_accessor :values, :controller
  def initWithFrame(frame)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    @label = ""
    @selected = ""
    @tapSet = false
    @popup = false
    @title = ""
    self.opaque = false
    super
  end
  def setTitle(title)
    @title = title
  end
  def setCallback(cb)
    @cb = cb
  end
  def setPopup(popup)
    @popup = popup
  end
  def setLabel(label)
    unless @tapSet
      @tapSet = true
    end
    @label = label
    self.setNeedsDisplay
  end
  def setValues(values, selected = 0)
    @values = values
    self.select selected
  end
  def select(id)
    if id.is_a? String
      i = 0
      @values.each do |val|
        if val[:id] == id
          @selected = i
        end
        i += 1
      end
    else
      @selected = id
    end
    if !@controller.nil? and !@values.nil? and !@selected.nil? and !values[@selected].nil?
      @controller.send(@cb, @values[@selected][:id])
    end
    self.setNeedsDisplay
  end
  def singleTap(tap)
    key = @values[@selected][:key]
    val = @values[@selected][:val]
    if @popup
      @popup.open(@values, @title, self)
    end
  end
  def drawRect(rect)
    # rect.origin.x += 0.5
    # rect.size.width -= 0.5
    size = rect.size.clone
    origin = rect.origin.clone
    borderC = "#DDE381".uicolor
    labelBgC = "#B1BB25".uicolor
    labelTxtC = "#FAFFB1".uicolor
    labelPad = 15

    button = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:6.0)
    borderC.setFill
    button.fill

    labelAttrd = @label.upcase.attrd({
      NSFontAttributeName => Font.Vitesse_Bold(12),
      UITextAttributeTextColor => labelTxtC
    })
    labelBounded = labelAttrd.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    labelW = labelBounded.size.width
    labelRect = rect.clone
    labelRect.size.width = labelW+(labelPad*2)
    labelRect.origin.y += 1
    labelRect.origin.x += 1
    labelRect.size.height -= 2
    labelBg = UIBezierPath.bezierPathWithRoundedRect(labelRect,
      byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft,
      cornerRadii: CGSizeMake(6.0, 6.0)
    )
    labelBgC.setFill
    labelBg.fill
    heightPad = (labelRect.size.height - labelBounded.size.height)/2
    labelAttrd.drawInRect(CGRectInset(labelRect, labelPad, heightPad))

    maskRect = rect.clone
    maskRect.size.width = maskRect.size.width - labelRect.size.width - 1
    maskRect.origin.y += 1
    maskRect.origin.x += labelRect.size.width
    maskRect.size.height -= 2
    mask = UIBezierPath.bezierPathWithRoundedRect(maskRect,
      byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight,
      cornerRadii: CGSizeMake(6.0, 6.0)
    )
    Color.bright_green.setFill
    mask.fill

    if !@values.nil? && !@values[@selected].nil?
      vRect = rect.clone
      vRect.size.width = rect.size.width - labelRect.size.width
      vRect.origin.x = labelRect.size.width

      valAttrd = @values[@selected][:val].attrd({
        NSFontAttributeName => Font.Karla_Bold(15),
        UITextAttributeTextColor => Color.white
      })
      valBounded = valAttrd.boundingRectWithSize(vRect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      valW = valBounded.size.width
      valRect = rect.clone
      valRect.size.width = labelRect.size.width+(labelPad*2)
      valRect.origin.x = labelRect.size.width + ((vRect.size.width/2) - (valBounded.size.width/2))
      valRect.origin.y = (rect.size.height - valBounded.size.height)/2
      valAttrd.drawInRect(valRect)
    end

    super
  end
end