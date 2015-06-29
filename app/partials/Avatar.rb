class Avatar < UIView
  def viewDidLoad
    updateImgFrame
  end
  def setImg(url)
    self.backgroundColor = Color.clear
    self.subviews.makeObjectsPerformSelector('removeFromSuperview')
    @imgView = UIImageView.alloc.initWithFrame([[0,0],[0,0]])
    @imgView.contentMode = UIViewContentModeScaleAspectFill
    updateImgFrame
    @imgView.setImageWithURL NSURL.URLWithString(url), placeholderImage:UIImage.imageNamed("default-avatar.png")
    self.addSubview @imgView
  end
  def updateImgFrame(rect = false)
    @stroke = 3 if @stroke.nil?
    @imgViewFrame = rect ? rect : self.frame
    @imgViewFrame.size.width -= @stroke * 2
    @imgViewFrame.size.height -= @stroke * 2
    @imgViewFrame.origin.y = @stroke
    @imgViewFrame.origin.x = @stroke
    unless @imgView.nil?
      @imgView.setFrame @imgViewFrame
      shapeLayer = CAShapeLayer.layer
      shapeLayer.path = path.CGPath
      @imgView.layer.mask = shapeLayer
    end
  end
  def setStroke(stroke)
    @stroke = stroke
  end
  def setSize(width, height, update = false)
    @width = width
    @height = height
    if update
      updateImgFrame
      self.setNeedsDisplay
    end
  end
  def path
    rect = CGRectMake(0,0, @imgViewFrame.size.width, @imgViewFrame.size.width)
    path = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:(@imgViewFrame.size.width * 0.225))
    path
  end
  def drawRect(rect)
    light_tan = Color.light_tan
    path = UIBezierPath.bezierPathWithRoundedRect(rect, cornerRadius:(rect.size.width * 0.225))
    light_tan.setFill
    path.fill
    updateImgFrame(rect)
    super
  end
end