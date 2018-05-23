class AttendeeSearchTitleLayout < MK::Layout
  def setResultsTable(table)
    @results_table = table
  end
  def setController(controller)
    @controller = controller
  end
  def layout
    add UIButton, :globe_icon
    add NotificationMarker, :notification_marker
    add UIButton, :close_button
    add UIView, :search_attendees do
      add UIImageView, :search_icon
      add UITextField, :search_attendees_input
      add UIButton, :clear_button
    end
  end
  def watchNotifications
    Fire.watch "value", '/users/'+Me.atn.user_id.to_s+'/notification_count' do |rsp|
      count = 0
      unless rsp.value.nil?
        count = rsp.value
      end
      get(:notification_marker).setCount(count)
    end
  end
  def super_width
    self.view.frame.size.width
  end
  def notification_marker_style
    # hidden true
    target.on_tap do
      @controller.open_notifications
    end
    target.setCount 0
    watchNotifications
    backgroundColor Color.clear
    constraints do
      width 20
      height 20
      top Device.x(22, 28)
      left 5
    end
  end
  def globe_icon_style
    target.on_tap do
      @controller.open_notifications
    end
    image UIImage.imageNamed("globe_logo")
    constraints do
      width 25
      height 25
      bottom Device.x(-8, -2)
      left 7
    end
  end
  def close_button_style
    target.addTarget self, action: 'stopSearch', forControlEvents:UIControlEventTouchUpInside
    title "Cancel"
    font Font.Karla(15)
    constraints do
      width 80
      height 25
      right 2
      bottom Device.x(-8, -2)
    end
  end
  def clear_button_style
    target.setImage Ion.imageByFont(:ios_close_outline, color:Color.white), forState:UIControlStateNormal
    target.addTarget self, action: 'resetSearch', forControlEvents:UIControlEventTouchUpInside
    hidden true
    constraints do
      width 22
      height 22
      right -3
      top 4
    end
  end
  def search_icon_style
    image Ion.imageByFont(:ios_search_strong, color:Color.white)
    constraints do
      top 4
      left 6
      width 22
      height 22
    end
  end
  def search_attendees_style
    constraints do
      bottom Device.x(-6, -2)
      @search_right = right -6
      @search_width = width.equals(super_width - 46)
      height 30
    end
    backgroundColor Color.light_blue
    target.layer.setCornerRadius(5.0)
    target.layer.masksToBounds = true
  end
  def search_attendees_input_style
    textColor Color.white
    backgroundColor Color.clear
    attributedPlaceholder NSAttributedString.alloc.initWithString("Search Attendees", attributes:{
      NSForegroundColorAttributeName => Color.white
    })
    target.autocorrectionType = UITextAutocorrectionTypeNo
    font Font.Karla(16)
    target.addTarget self, action:'search_action', forControlEvents:UIControlEventEditingChanged
    delegate self
    constraints do
      top 9
      left 28
      width.equals(:superview).minus(15)
      height.equals(:superview).minus(13)
    end
  end
  def setSearch(search)
    get(:search_attendees_input).text = search
    search_action
  end
  def startSearch
    @controller.startSearch
    @search_width.equals(super_width - 80)
    @search_right.equals(-74)
    get(:notification_marker).fade_out(0.13)
    UIView.animateWithDuration(0.13, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    0.04.seconds.later do
      get(:clear_button).setHidden false
    end
  end
  def stopSearch
    get(:search_attendees_input).resignFirstResponder
    get(:search_attendees_input).text = ''
    get(:notification_marker).fade_in(0.13)
    @search_right.equals(-4)
    @search_width.equals(super_width - 45)
    UIView.animateWithDuration(0.13, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
    0.04.seconds.later do
      get(:clear_button).setHidden true
    end
    @controller.stopSearch
  end
  def resetSearch
    get(:search_attendees_input).text = ''
  end
  def search_action
    @query = get(:search_attendees_input).text
    if ['friends', 'friended me', 'match me'].include? @query
      Api.get 'user/friends_by_type', {include_user: 1, type: @query} do |rsp|
        if rsp.is_err
          $APP.offline_alert
        else
          @results_table.update_results rsp.user
          @controller.respondToSearch
        end
      end
    else
      @lastKeyTime = NSDate.new.timeIntervalSince1970
      ready_to_search
    end
  end
  def ready_to_search
      results = Assets.searchAttendees(@query).map { |hash| hash.stringify_keys }
      @results_table.update_results results
      @controller.respondToSearch
  end

  # Search field delegate
  def textFieldDidBeginEditing(textField)
    if textField == get(:search_attendees_input)
      startSearch
    end
  end
  def textFieldDidEnd(textField)
    if textField == get(:search_attendees_input)
      stopSearch
    end
  end
end