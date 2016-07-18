class WDTextField < SZTextView
	def textRectForBounds(bounds)
		puts 'TEXT RECT FOR BOUNDS'
		CGRectMake(bounds.origin.x+10, bounds.origin.y+10, bounds.size.width-20,
		bounds.size.height-20)
	end
	def editingRectForBounds(bounds)
		self.textRectForBounds
	end
end
