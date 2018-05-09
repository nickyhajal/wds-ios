class AtnStoryCell < UIView
  attr_accessor :cell, :state
  def initWithFrame(frame)
    super
  end
  def on_tap(x, y)
    @cell.controller.open_atn_story_action
  end
  def drawRect(rect)
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

    @btnStr = "Share Your Attendee Story!".attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(18),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @detailsStr = "Submissions close Saturday at 2:00pm".attrd({
      NSFontAttributeName => Font.Karla_Italic(13),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @bulbStr = "🎙".attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(32),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @btnStr.drawAtPoint(CGPointMake(46, 11))
    @bulbStr.drawAtPoint(CGPointMake(8, 11))
    @detailsStr.drawAtPoint(CGPointMake(46, 31))
    if @arrow.nil?
      @arrow = UILabel.alloc.initWithFrame(CGRectMake(self.frame.size.width-20, 18, 24, 24))
      @arrow.attributedText = Ion.icons[:ios_arrow_forward].attrd({
        NSFontAttributeName => IonIcons.fontWithSize(20),
        UITextAttributeTextColor => "#999590".uicolor
      })
      self.addSubview @arrow
    end
  end
end
