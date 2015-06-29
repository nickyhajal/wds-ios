class ProgressDots < UIView
  def initWithFrame(frame)
    self.backgroundColor = Color.clear
    @selected = 0
    @numDots = 0
    super
  end
  def setNumDots(num)
    @selected = 0 if @selected.nil?
    @numDots = num
    self.setNeedsDisplay
  end
  def setSelected(num)
    @selected = num
    self.setNeedsDisplay
  end
  def drawRect(rect)
    light_tan = Color.light_tan
    light_tan.setFill
    light_tan.setStroke
    dotSize = 9
    x = ((self.frame.size.width/2 - ((dotSize+6) * @numDots)/2)) + dotSize*0.5
    for i in 0..(@numDots-1)
      dot_rect = CGRectMake(x, 0, dotSize, dotSize)
      dot_rect = CGRectInset(dot_rect, 1, 1) if i != @selected
      path = UIBezierPath.bezierPathWithRoundedRect(dot_rect, cornerRadius:(dotSize*0.5))
      if i == @selected
        path.fill
      else
        path.stroke
      end
      x += (dotSize+(dotSize*0.5))
    end
    super
  end
end