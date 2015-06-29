class AttendeeSearchTitleLayout < MK::Layout
  def setResultsTable(table)
    @results_table = table
  end
  def setController(controller)
    @controller = controller
  end
  def layout
    add UIImageView, :globe_icon
    add UIButton, :close_button
    add UIView, :search_attendees do
      add UIImageView, :search_icon
      add UITextField, :search_attendees_input
      add UIButton, :clear_button
    end
  end
  def super_width
    self.view.frame.size.width
  end
  def globe_icon_style
    image UIImage.imageNamed("globe_logo")
    constraints do
      width 25
      height 25
      top 26
      left 9
    end
  end
  def close_button_style
    target.addTarget self, action: 'stopSearch', forControlEvents:UIControlEventTouchUpInside
    title "Cancel"
    font Font.Karla(15)
    constraints do
      width 80
      height 25
      right 0
      top 26
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
      top 23
      @search_right = right -4
      @search_width = width.equals(super_width - 45)
      height 30
    end
    backgroundColor Color.bright_green
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
    font UIFont.fontWithName("Karla", size:16.0)
    target.addTarget self, action:'search_action', forControlEvents:UIControlEventEditingChanged
    delegate self
    constraints do
      top 7
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
    @search_right.equals(-76)
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
      1.seconds.later do
        ready_to_search
      end
    end
  end
  def ready_to_search
    diff = NSDate.new.timeIntervalSince1970 - @lastKeyTime
    if diff > 1
      Api.get 'users', {search: @query} do |rsp|
        if rsp.is_err
          $APP.offline_alert
        else
          @results_table.update_results rsp.users
          @controller.respondToSearch
        end
      end
    end
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