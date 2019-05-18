class NotificationsScreen < PM::Screen
  title "Notes"
  status_bar :light
  attr_accessor :layout
  def on_load
    @layout = NotificationsLayout.new(root: self.view)
    @layout.setController self
    @table = NotificationsListing.new
    @table.layout = @layout
    @table.controller = self
    @layout.table = @table.view
    @layout.build
    @dispatch_screen = DispatchItemScreen.new(nav_bar: false)
    @attendee_screen = AttendeeScreen.new(nav_bar: false)
    @chat_screen = ChatScreen.new(nav_bar: false)
    syncState
    true
  end
  def sync
    setState 'loading'
    Api.get 'user/notifications', {} do |rsp|
      Crashlytics.sharedInstance.setObjectValue(rsp, forKey: 'notificationResponse')
      # if !rsp.respond_to?('notifications') or rsp.notifications.nil? or rsp.notifications.length < 1
      if !rsp.respond_to? 'notifications' or rsp.notifications.nil? or rsp.notifications.length < 1
        setState 'null'
        showNullMsg
      else
        setState 'loaded'
        @table.update(rsp.notifications)
        showNotifications
        mark_read
      end
    end
  end
  def setState(state)
    @state = state
    syncState
  end
  def syncState
    case @state
    when 'loading'
      showLoadingMsg
    when 'null'
      showNullMsg
    when 'loaded'
      showNotifications
    end
  end
  def mark_read
    Api.post 'user/notifications/read', {} do |rsp|
      Me.fireSet('notification_count/', 0)
    end
  end
  def open_notification_action(notn)
    notn.open self do |rsp|
      sync
    end
  end
  def open_profile(user_id)
    @attendee_screen.setAttendee user_id
    open_modal @attendee_screen
  end
  def open_dispatch(item, options = {})
    is_id = options[:is_id] || false
    @dispatch_screen.setItem item, is_id
    open_modal @dispatch_screen
  end
  def open_chat(pid, name)
    @chat_screen.setChatFromPid({pid: pid, name: name})
    open_modal @chat_screen
  end
  def showLoadingMsg
    unless @layout.nil?
      @layout.get(:loading_msg).setHidden false
      @layout.get(:null_msg).setHidden true
      @layout.get(:notns_list).setHidden true
    end
  end
  def showNullMsg
    unless @layout.nil?
      @layout.get(:loading_msg).setHidden true
      @layout.get(:null_msg).setHidden false
      @layout.get(:notns_list).setHidden true
    end
  end
  def showNotifications
    unless @layout.nil?
      @layout.get(:loading_msg).setHidden true
      @layout.get(:null_msg).setHidden true
      @layout.get(:notns_list).setHidden false
    end
  end

  # Deprecate
  def hideNullMsg
    showNotifications
  end
  def close_action
    close_screen
  end
  def shouldAutorotate
    false
  end
end