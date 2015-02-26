class AttendeeSearchTitleLayout < MK::Layout
  def layout
    add UIImageView, :globe_icon do
      @logo_image = image UIImage.imageNamed("globe_logo")
    end
    add UIView, :search_attendees do
      add UITextField, :search_attendees_input
    end
  end
  def globe_icon_style
    constraints do
      width 25
      height 25
      top 26
      left 9
    end
  end
  def search_attendees_style
    constraints do
      top 23
      right -4
      width.equals(:superview).minus(45)
      height 30
    end
    backgroundColor "#E3E894".uicolor
    target.layer.setCornerRadius(5.0)
    target.layer.masksToBounds = true
  end
  def search_attendees_input_style
    constraints do
      top 7
      left 25
      width.equals(:superview).minus(12)
      height.equals(:superview).minus(13)
    end
    textColor "#89901E".uicolor
    backgroundColor UIColor.clearColor
    attributedPlaceholder NSAttributedString.alloc.initWithString("Search Attendees", attributes:{
      NSForegroundColorAttributeName => "#89901E".uicolor
    })
    font UIFont.fontWithName("Karla", size:16.0)
  end
end