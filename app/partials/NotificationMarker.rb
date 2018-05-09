class NotificationMarker < UIView
	def initWithFrame(frame)
		@count = 0
		super
	end
	def setCount(count)
		@count = count.to_i
		if count > 0
			self.setHidden false
			self.setNeedsDisplay
		else
			self.setHidden true
			self.setNeedsDisplay
		end
	end
	def drawRect(rect)
		# bgC = "#E2ED46".uicolor
		bgC = "#F23E06".uicolor
		bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius:rect.size.width/2)
    bgC.setFill
    bgPath.fill
		# fgC = "#F23E06".uicolor
		# fgR = rect
		# fgR.origin.x = 2
		# fgR.origin.y = 2
		# fgR.size.width -= 4
		# fgR.size.height -= 4
		# fgPath = UIBezierPath.bezierPathWithRoundedRect(fgR, cornerRadius:fgR.size.width/2)
  #   fgC.setFill
  #   fgPath.fill
		@countStr = @count.to_s.attrd({
      NSFontAttributeName => Font.Karla_Italic(12),
      UITextAttributeTextColor => Color.white
    })
    @countBox = @countStr.boundingRectWithSize(CGSizeMake(Float::MAX, Float::MAX), options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    x = ((rect.size.width / 2) - (@countBox.size.width / 2))
    @countStr.drawAtPoint(CGPointMake(x, 2))
	end
end