class ExploreScreen < PM::Screen
  title "Explore"
  status_bar :light
  def on_init
    selected = UIImage.imageNamed("explore_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("explore_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_nav_bar_button :right, title: "Check In", action: 'check_in_action'
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      title: ''
    })
    @timer = false
    @checkin_screen = CheckInScreen.new(nav_bar: false)
    @place_screen = PlaceScreen.new(nav_bar: false)
    @placeList = PlaceListing.new
    @placeList.controller = self
    @lastClosest = false
    @lastPingClosest = false
    @lastCheck = 0
    @lastCheckinTime = 0
    @pinging = false
    @checkingCheckins = false
    @frequency = 60
  end
  def check_in_action
    open @checkin_screen
  end
  def open_place(place)
    @place_screen.setPlace(place)
    open @place_screen
  end
  def change_sort_action(sender)
    selector = @layout.get(:sort_selector)
    val = selector.selectedSegmentIndex
    if val == 0
      @placeList.sort = :order_distance
    elsif val == 1
      @placeList.sort = :checkins
    end
    update_places
  end
  def on_select
    val = @layout.get(:selector).selected
    @placeList.type = val[:id]
    @lastCheckin = false
    @layout.get(:place_list).setContentOffset(CGPointMake(0, -@layout.get(:place_list).contentInset.top), animated:false)
    update_places
  end
  def on_load
    @layout = ExploreLayout.new(root: self.view)
    @layout.place_view = @placeList.view
    @placeList.setLayout @layout
    @layout.setController self
    @layout.build
    update_places
    true
  end
  # def start_waitToCheckin
  #   puts '>> START WAIT'
  #   @waitTimer = 330.seconds.later do
  #     if BW::Location.enabled? # If location is disabled, we can't trust the wait
  #       puts '>> CHECKIN VIA WAIT'
  #       do_checkin
  #     end
  #     start_waitToCheckin
  #   end
  # end
  # def start_location_services
  #   if BW::Location.enabled?
  #     BW::Location.get_significant(purpose: "We'd like to use your location to help you explore Portland and connect with other WDSers!") do |result|
  #       puts 'GET SIG'
  #       if @waitTimer
  #         puts '>> INVALIDATE WAIT'
  #         @waitTimer.invalidate
  #       end
  #       @placeList.position = result[:to]
  #       @checkin_screen.placeList.position = result[:to]
  #       update_places
  #       @checkin_screen.update_places

  #       # If we move, get_significant will be called and invalidate this timer
  #       start_waitToCheckin
  #     end
  #   end
  # end
  def on_appear
    @update = true
    unless @checkingCheckins
      update_checkins
    end
    unless @pinging
      location_ping
    end
    @frequency = 45
  end
  def open_location_permission_primer
      Store.set('asked_for_location', 0)
      asked = Store.get('asked_for_location')
      asked = 0 if !asked
      now = NSDate.new.timeIntervalSince1970
      diff = now.to_f - asked.to_f
      if diff > 432000
        Store.set('asked_for_location', now)
        str = "We use your location to help you find places and attendees near you that you might like.\n\nShare your location to make sure you don't miss out!"
        modal = {
          title: 'Share Your Location!',
          content: str,
          close_on_yes: true,
          image: "locationIcon".uiimage,
          yes_text: "Yup, let's do it!",
          no_text: "No, thanks.",
          yes_action: 'location_allow',
          controller: self
        }
        @layout.get(:permission).open(modal)
      end
  end
  def location_allow(item)
    Store.set('hasLocationPermission', true)
    location_ping
  end
  def location_ping
    @pinging = true
    hasPermission = Store.get('hasLocationPermission', false)
    if BW::Location.enabled?
      if !hasPermission
        open_location_permission_primer
      else
        BW::Location.get_once(purpose: "We'd like to use your location to help you explore Portland and connect with other WDSers!") do |result|
          if result.is_a?(CLLocation)
            @placeList.position = result
            @checkin_screen.placeList.position = result
            update_places(true)
            @checkin_screen.update_places
            now = NSDate.new.timeIntervalSince1970
            if (now - @lastCheck) > 40 && Me.shouldAutoCheckIn
              @lastCheck = now
              if @lastPingClosest == @placeList.closest
                if @lastPingClosest
                  do_checkin
                end
              end
              @lastPingClosest = @placeList.closest
            end
          else
            puts "ERROR: #{result[:error]}"
          end
        end
        @frequency.seconds.later do
          location_ping
        end
      end
    end
  end
  def do_checkin
    if @placeList.lastClosest < 400
      place = @placeList.closest
      now = NSDate.new.timeIntervalSince1970
      if @lastCheckin != place || (now-@lastCheckinTime) > 300
        @lastCheckin = place
        @lastCheckinTime = now
        params = {location_id: place[:place_id], location_type: 'place'}
        Api.post 'user/checkin', params do |rsp|
        end
      end
    end
  end
  def on_disappear
    @update = false
    @frequency = 60
  end
  def update_checkins
    @checkingCheckins = true
    Api.get "checkins/recent", {by_id: 1} do |rsp|
      unless rsp.is_err
        @placeList.checkins = rsp.checkins
        update_places
        if @update
          15.seconds.later do
            update_checkins
          end
        else
          @checkingCheckins = false
        end
      end
    end
  end
  def update_places(soft_update = false)
    Assets.getSmart "places" do |places, status|
      @placeList.allPlaces = places
      @placeList.update_items(soft_update)
    end
  end
end