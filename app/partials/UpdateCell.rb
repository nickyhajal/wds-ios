class UpdateCell < UIView
  attr_accessor :cell, :state
  def initWithFrame(frame)
    super
  end
  def on_tap(x, y)
    app = "itms-apps://itunes.apple.com/us/app/wds-app/id992669601?mt=8".nsurl
    UIApplication.sharedApplication.openURL(app)
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

    @btnStr = " 🎉   Get the New App Update!".attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(18),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @btnStr.drawAtPoint(CGPointMake(8, 22))
    if @arrow.nil?
      @arrow = UILabel.alloc.initWithFrame(CGRectMake(self.frame.size.width-40, 16, 30, 30))
      @arrow.attributedText = Ion.icons[:ios_cloud_download_outline].attrd({
        NSFontAttributeName => IonIcons.fontWithSize(24),
        UITextAttributeTextColor => "#999590".uicolor
      })
      self.addSubview @arrow
    end
  end
end
