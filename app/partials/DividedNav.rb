class DividedNav < UIView
  def initWithFrame(frame)
    view = super
    self.backgroundColor = Color.bright_tan
    @buttons = []
    @lines = []
    @widths = []
    view
  end
  def setSize(width, height)
    @width = width
    @height = height
  end
  def setController(controller)
    @controller = controller
  end
   def setButtons(btns)
    btns.each do |btn|
      opts = btn[3].nil? ? {} : btn[3]
      addButton btn[0], btn[1], btn[2], opts
    end
    layout
  end
  def setButtonText(index, text)
    @buttons[index].title = text
  end
  def addButton(title, target, action, opts)
    width = opts[:width].nil? ? 38 : opts[:width]
    btn = UIButton.alloc.initWithFrame([[0,0], [width,10]])
    btn.addTarget target, action: action, forControlEvents:UIControlEventTouchDown
    btn.lineBreakMode =  NSLineBreakByTruncatingTail
    btn.backgroundColor = Color.clear
    btn.setTitle(title, forState:UIControlStateNormal)
    btn.titleLabel.font = Font.Vitesse_Medium(15)
    btn.contentEdgeInsets = UIEdgeInsetsMake(9, 12, 9, 12)
    btn.setTitleColor(Color.dark_gray, forState:UIControlStateNormal)
    btn.sizeToFit
    if opts[:width].nil?
      @widths << 0
    else
      frame = btn.frame
      frame.size.width = opts[:width]
      btn.setFrame frame
      @widths << opts[:width]
    end
    line = UIView.alloc.initWithFrame([[0,0], [1, @height]])
    line.backgroundColor = Color.light_gray
    @lines << line
    @buttons << btn
  end
  def drawBottomLine
    @bot_line = UIView.alloc.initWithFrame([[0,@height-1], [@width, 1]])
    @bot_line.backgroundColor = Color.light_gray
    self.addSubview @bot_line
  end
  def layout
    x = 0
    count = 0
    base_width = 0
    add_width = 0
    num_need_width = 0
    @buttons.each do |btn|
      base_width += btn.frame.size.width
      if @widths[count] == 0
        num_need_width += 1
      end
      count += 1
    end
    count = 0
    if base_width < @width
      add_width = ((@width - base_width) / num_need_width).ceil
    end
    @buttons.each do |btn|
      line = @lines[count]
      l_frame = line.frame
      frame = btn.frame
      if @widths[count] == 0
        frame.size.width += add_width
      end
      frame.origin.x = x
      l_frame.origin.x = x + frame.size.width
      line.setFrame l_frame
      btn.setFrame frame
      self.addSubview btn
      self.addSubview line
      x += frame.size.width
      count += 1
    end
    drawBottomLine
  end
end