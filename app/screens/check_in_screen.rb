class CheckInScreen < PM::Screen
  title "Check In"
  status_bar :light
  attr_accessor :placeList
  def on_init
    @updating_started = false
    @placeList = PlaceListing.new
    @placeList.checkinScreen = true
    @placeList.controller = self
  end
  def on_load
    @layout = CheckInLayout.new(root: self.view)
    @layout.place_view = @placeList.view
    @placeList.setLayout @layout
    @layout.setController self
    @layout.build
    update_places
    true
  end
  def do_checkin(cell)
    place = cell.place
    params = {location_id: place[:place_id], location_type: 'place'}
    Api.post "user/checkin", params do |rsp|
      cell.checkinMessage = 'Checked In!'
      cell.setNeedsDisplay
      1.5.seconds.later do
        close_screen
        cell.checkinMessage = 'Check In'
        cell.setNeedsDisplay
      end
    end
  end
  def auto_change
    puts @layout.get(:auto_switch).isOn
    Me.setSetting('auto_checkin', @layout.get(:auto_switch).isOn)
  end
  def on_disappear
    @update = false
  end
  def update_places
    Assets.getSmart "places" do |places, status|
      @placeList.allPlaces = places
      @placeList.update
    end
  end
end