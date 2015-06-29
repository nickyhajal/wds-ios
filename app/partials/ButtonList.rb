class ButtonList < UIView
  def initWithFrame(frame)
    @buttons = []
    super
  end
  def setMaxWidth(width)
    @maxWidth = width
  end
  def setHeightConstraint(constraint)
    @heightConstraint = constraint
  end
  def layout
    clear
    nextX = 0
    lastY = 0
    padding_x = 5
    padding_y = 2
    @buttons.each do |btn|
      if nextX + btn.frame.size.width < @maxWidth
        x = nextX
        y = lastY
      else
        x = 0
        y = lastY = lastY + 38 + padding_y
      end
      nextX = x + btn.frame.size.width + padding_x
      frame = btn.frame
      frame.origin.x = x
      frame.origin.y = y
      btn.setFrame frame
      self.addSubview btn
    end
    @heightConstraint.equals(lastY + 34)
  end
  def setButtons(btns)
    erase
    btns.each do |btn|
      addButton btn[0], btn[1], btn[2]
    end
    layout
  end
  def addButton(title, target, action)
    btn = UIButton.alloc.initWithFrame([[0,0], [38,10]])
    btn.addTarget target, action: action, forControlEvents:UIControlEventTouchDown
    btn.backgroundColor = Color.yellowish_tan
    btn.setTitle(title, forState:UIControlStateNormal)
    btn.titleLabel.font = Font.Karla_Bold(14)
    btn.contentEdgeInsets = UIEdgeInsetsMake(9, 12, 9, 12)
    btn.setTitleColor(Color.gray, forState:UIControlStateNormal)
    btn.sizeToFit
    @buttons << btn
  end
  def erase
    clear(true)
  end
  def clear(erase = false)
    @buttons.each do |btn|
      btn.removeFromSuperview
    end
    if erase
      @buttons = []
    end
  end
end