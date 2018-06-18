class AnnouncementCell < UIView
  attr_accessor :cell, :state
  def initWithFrame(frame)
    super
  end
  def on_tap(x, y)
    if !@state[:link].nil?  && @state[:link].length > 0
      app = @state[:link].nsurl
      UIApplication.sharedApplication.openURL(app)
    end
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

    @btnStr = @state[:message].attrd({
      NSFontAttributeName => Font.Karla_BoldItalic(18),
      UITextAttributeTextColor => "#999590".uicolor
    })
    @btnStr.drawAtPoint(CGPointMake(8, 22))
    if @arrow.nil?
      @arrow = UILabel.alloc.initWithFrame(CGRectMake(self.frame.size.width-40, 16, 30, 30))

      self.addSubview @arrow
    end
    icon = @state[:icon].nil? ? :ios_cloud_download_outline : @state[:icon].to_sym
    iconStr = Ion.icons[icon]
    if !iconStr.nil? &&  iconStr.length > 0
      @arrow.attributedText = iconStr.attrd({
        NSFontAttributeName => IonIcons.fontWithSize(24),
        UITextAttributeTextColor => "#999590".uicolor
      })
    end
  end
end
