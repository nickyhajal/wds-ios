class AttendeeSearchTitleLayout < MK::Layout
  def setResultsTable(table)
    @results_table = table
  end
  def setController(controller)
    @controller = controller
  end
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
    textColor "#89901E".uicolor
    backgroundColor UIColor.clearColor
    attributedPlaceholder NSAttributedString.alloc.initWithString("Search Attendees", attributes:{
      NSForegroundColorAttributeName => "#89901E".uicolor
    })
    font UIFont.fontWithName("Karla", size:16.0)
    target.addTarget self, action:'search_action', forControlEvents:UIControlEventEditingChanged
    constraints do
      top 7
      left 25
      width.equals(:superview).minus(12)
      height.equals(:superview).minus(13)
    end
  end
  def search_action
    @query = get(:search_attendees_input).text
    @lastKeyTime = NSDate.new.timeIntervalSince1970
    1.seconds.later do
      ready_to_search
    end
  end
  def ready_to_search
    diff = NSDate.new.timeIntervalSince1970 - @lastKeyTime
    if diff > 1
      Api.get 'users', {search: @query} do |rsp|
        results_view = @controller.get(:attendee_results)
        atns = rsp['json']['users']
        @results_table.update_results atns
        results_view.setHidden false
      end
    end
  end
end