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
      title: 'Explore'
    })
    @timer = false
    @updating_started = false
    @checkin_screen = CheckInScreen.new(nav_bar: false)
    @placeList = PlaceListing.new
    @placeList.controller = self
  end
  def check_in_action
    open @checkin_screen
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
  def start_location_services
    if BW::Location.enabled?
      BW::Location.get_significant(purpose: "We'd like to use your location to help you explore Portland and connect with other WDSers!") do |result|
        @updating_started = true
        puts '>> SIG'
        puts result.inspect
        puts result[:to].inspect
        @placeList.position = result[:to]
        @checkin_screen.placeList.position = result[:to]
        update_places
        do_checkin
      end
    end
  end
  def on_appear
    @update = true
    start_location_services
    update_checkins
    location_ping
  end
  def location_ping
    if BW::Location.enabled?
      BW::Location.get_once(purpose: "We'd like to use your location to help you explore Portland and connect with other WDSers!") do |result|
        if Me.shouldAutoCheckIn
          @updating_started = true
          if result.is_a?(CLLocation)
            @placeList.position = result
            @checkin_screen.placeList.position = result
            update_places
            do_checkin
          else
            puts "ERROR: #{result[:error]}"
          end
        end
      end
    end
    if @update
      20.seconds.later do
        location_ping
      end
    end
  end
  def do_checkin
    if @placeList.lastClosest < 400
      place = @placeList.closest
      if @lastCheckin != place
        @lastCheckin = place
        params = {location_id: place[:place_id], location_type: 'place'}
        puts '>> CHECKIN'
        puts params
        Api.post 'user/checkin', params do |rsp|
        end
      end
    end
  end
  def on_disappear
    @update = false
  end
  def update_checkins
    puts 'UPDATE CHECKINS'
    Api.get "checkins/recent", {by_id: 1} do |rsp|
      unless rsp.is_err
        @placeList.checkins = rsp.checkins
        update_places
        if @update
          10.seconds.later do
            update_checkins
          end
        end
      end
    end
  end
  def update_places
    Assets.getSmart "places" do |places, status|
      @placeList.allPlaces = places
      @placeList.update
    end
  end
end