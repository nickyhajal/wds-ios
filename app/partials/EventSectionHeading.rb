class EventSectionHeading < UILabel
  def drawTextInRect(rect)
    super(UIEdgeInsetsInsetRect(rect, [1,13,0,5]))
  end
end