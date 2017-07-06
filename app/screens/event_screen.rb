class EventScreen < PM::Screen
  attr_accessor :layout
  include EventModule
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
    @layout = EventLayout.new(root: self.view)
    @dispatch = Disptch.new
    @dispatch.setController self
    @event_atns = EventAttendees.new
    @event_atns.controller = self
    @layout.event_atn_view = @event_atns.view
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
  # def viewDidLayoutSubviews
  #   @layout.updateScrollSize
  # end
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
    @event_atns.update_results(atns)
    @layout.get(:atns_loading).setHidden true
    @layout.get(:atns).setHidden false
  end
  def setEvent(event, from = false)
    @from = from
    0.02.seconds.later do
      @event = event
      @post_screen.layout.get(:placeholder).text = "Share a message with "+@event.what
      @dispatch.clear
      @dispatch.setChannel('meetup', @event.event_id)
      @layout.get(:channel_nav).setButtonText 1, @event.what
      @layout.get(:scrollview).setContentOffset(CGPointMake(0, 0), animated: false)
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
    @dispatch.unwatch
    if !@from.nil? && @from
      page = 0
      if @from == "schedule"
        page = 1
      end
      @from = false
      $APP.open_tab(page)
    end
  end
  def open_confirm_action
    isAttending = Me.isAttendingEvent(@event)
    isFull = @event.isFull
    if (!isAttending || @event.type != 'academy')
      if isFull and (@event.type != 'academy' and isAttending)
        open_confirm
      elsif !isFull
        open_confirm
      end
    end
  end
  def open_confirm
    modal = confirmModal(@event)
    @layout.get(:modal).open(modal)
  end
  def doRsvp(event)
    if (!event.isFull || Me.isAttendingEvent(event))
      Me.toggleRsvp event do
        @layout.reapply!
      end
    end
    @layout.get(:modal).close
  end
  def claimAcademy(event)
    slug = event.slug
    modal = {
      item: event,
      title: 'Claiming...',
      content: "Hang tight while we claim your ticket...",
      yes_action: 'claimAcademy',
      instant_appear: true,
      yes_text: 'Claiming...',
      no_text: 'No, thanks.',
      controller: self
    }
    @layout.get(:modal).open(modal)
    Api.post "event/claim-academy", {'event_id' => event.event_id} do |rsp|
      modal = {
        item: event,
        title: 'Claimed!',
        content: "Nice, you're Insider Access ticket has been claimed!",
        yes_action: 'closeModal',
        instant_appear: true,
        yes_text: 'Claimed!',
        no_text: ' ',
        controller: self
      }
      @layout.get(:modal).open(modal)
      Me.addRsvp(event.event_id)
      Me.atn.academy = event.event_id
      @layout.reapply!
      8.seconds.later do
        closeModal
      end
    end
  end
  def closeModal
    @layout.get(:modal).close
  end
  def purchaseAcademy(event)
    @cart.setProduct('academy', event)
    @cart.setPurchasedCallback(self, 'academyPurchased', event)
    closeModal
    open_modal @cart
  end
  def academyPurchased(event)
    Me.addRsvp(event.event_id)
    @layout.reapply!
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