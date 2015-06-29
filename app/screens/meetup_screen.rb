class MeetupScreen < PM::Screen
  status_bar :dark
  title_view UILabel.new
  def on_init
    @from = false
  end
  def on_load
    @dispatch_screen = DispatchItemScreen.new(nav_bar: false)
    @attendee_screen = AttendeeScreen.new(nav_bar: false)
    @post_screen = PostScreen.new(nav_bar: false)
    @post_screen.controller = self
    @post_screen.init_layout
    @dispatch = Disptch.new
    @dispatch.setController self
    @layout = MeetupLayout.new(root: self.view)
    @meetup_atns = MeetupAttendees.new
    @meetup_atns.controller = self
    @layout.meetup_atn_view = @meetup_atns.view
    @layout.dispatch = @dispatch
    @layout.dispatch_view = @dispatch.view
    @event = false
    @layout.setController self
    @layout.build
    @dispatch.initParams({channel_type:'meetup', channel_id:300, layout: @layout, controller: self})
    #@dispatch.initFilters(@filters_screen.layout)
    @dispatch.setNewPostsBtn @layout.get(:new_posts), @layout.new_posts_y, self.view
    @post_screen.dispatch = @dispatch
    true
  end
  def open_profile(user_id)
    @attendee_screen.setAttendee user_id
    open_modal @attendee_screen
  end
  def open_dispatch(item, options = {})
    is_id = options[:is_id] || false
    @dispatch_screen.setItem item, is_id
    open_modal @dispatch_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def load_new_action
    @dispatch.loadNewViaButton
  end
  def show_post_action
    open_modal @post_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleDefault)
  end
  def show_communities_action
  end
  def leave_channel_action
    @layout.close_dispatch
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleDefault)
  end
  def loadAttendees(atns)
    @meetup_atns.update_results(atns)
    @layout.get(:atns_loading).setHidden true
    @layout.get(:atns).setHidden false
  end
  def setMeetup(event, from = false)
    @from = from
    0.02.seconds.later do
      @event = event
      @dispatch.clear
      @dispatch.setChannel('meetup', @event.event_id)
      @layout.get(:channel_nav).setButtonText 1, @event.what
      @layout.slideClosed(0.0)
      @layout.updateEvent @event
    end
  end
  def updateTitle
    frame = @layout.view.frame
    size = frame.size
    @title.text = @event.what
  end
  def back_action
    close_screen
    puts @from
    if !@from.nil? && @from
      page = 0
      if @from == "schedule"
        page = 1
      end
      @from = false
      $APP.open_tab(page)
    end
  end
  def rsvp_action
    if !@event.isFull
      Me.toggleRsvp @event do
        @layout.reapply!
      end
    end
  end
  def go_to_directions_action
    chrome = "comgooglemaps://"
    chromeURL = NSURL.URLWithString(chrome)
    destination = @event.lat.to_s+','+@event.lon.to_s
    if UIApplication.sharedApplication.canOpenURL(chromeURL)
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(chrome+'?daddr='+destination+'&directionsmode=walking'))
    else
      place = MKPlacemark.alloc.initWithCoordinate(CLLocationCoordinate2DMake(@event.lat, @event.lon), addressDictionary: nil)
      item = MKMapItem.alloc.initWithPlacemark(place)
      item.setName(@event.place)
      currentLocationMapItem = MKMapItem.mapItemForCurrentLocation
      launchOptions = {
        MKLaunchOptionsDirectionsModeKey => MKLaunchOptionsDirectionsModeWalking
      }
      MKMapItem.openMapsWithItems([currentLocationMapItem, item], launchOptions: launchOptions)
    end
  end
  def shouldAutorotate
    false
  end
end