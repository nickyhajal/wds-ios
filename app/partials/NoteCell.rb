class NoteCell < PM::TableViewCell
  attr_accessor :note, :width, :controller, :noteStr
  def initWithStyle(style, reuseIdentifier:id)
    @checkinMessage = "Check In"
    super
  end
  def will_display
    self.setNeedsDisplay
  end
  def getHeight
    if @cardView.nil?
      @cardView = NoteCellInnerView.alloc.initWithFrame([[0,0], [self.frame.size.width, self.frame.size.height]])
      @cardView.cell = self
      self.addSubview(@cardView)
    end
    size = self.frame.size
    size.width = @width - 36
    size.height = Float::MAX
    height = 3+15+15 # Top and bottom padding
    note = ""
    if !@note[:note].nil? && @note[:note].length() > 0
      note = @note[:note]
    end
    @noteStr = note.attrd({
      NSFontAttributeName => Font.Karla(16),
      UITextAttributeTextColor => Color.dark_gray
    })
    @noteBox = @noteStr .boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height += @noteBox.size.height
    return height
  end
  def note_rect
    @note_top = 10
    CGRectMake(18, 16, self.frame.size.width-36, Float::MAX)
  end
  def drawRect(rect)
    # Init
    height = getHeight
    size = rect.size
    @size = size
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end
  end
end


class NoteCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    # Colors
    orange = Color.orange
    white = Color.white
    tan = Color.tan

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius:0.0)
    tan.setFill
    bgPath.fill

    cardPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(3, 3, rect.size.width-6, rect.size.height-3), cornerRadius:0.0)
    white.setFill
    cardPath.fill

    @cell.noteStr.drawInRect(@cell.note_rect)
  end
end
