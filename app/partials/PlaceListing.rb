class PlaceListing < PM::TableScreen
  title "PlaceList"
  attr_accessor :type, :places, :controller, :allPlaces, :position, :closest, :lastClosest, :checkins, :sort, :checkinScreen
  row_height 144
  def on_init
    @checkinScreen = false
  end
  def on_load
    @type = 0
    @places = []
    @position = false
    @checkins = false
    @sort = :order_distance
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = Color.tan
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{
      cells: @places
    }]
  end
  def make_cell(place)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    {
      title: '',
      cell_class: PlaceCell,
      arguments: { place: place},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        place: place,
        checkinScreen: @checkinScreen,
        width: @width,
        controller: @controller
      }
    }
  end
  def isPicked(place)
    picks = {

    }
    picks.each do |pick|
      if pick[:place_id] == place[:place_id]
        place[:staff] = pick[:staff]
      end
    end
    if place[:staff].nil?
      false
    else
      place
    end
  end
  def processPositions(places)
    places.each do |place|
      placePos = CLLocation.alloc.initWithLatitude(place[:lat], longitude: place[:lon])
      distance = placePos.distanceFromLocation(@position) * 3.28084
      place[:order_distance] = distance
      place[:distance] = distance
      place[:units] = 'ft'
      if distance < lastClosest
        @closest = place
        @lastClosest = distance
      end
      if distance > 1000
        place[:distance] = (distance/5280)
        place[:units] = 'mi'
      end
      if @checkins
        id = place[:place_id]
        id = id.to_s
        if !@checkins[id].nil?
          place[:checkins] = @checkins[id][:num_checkins]
        end
      end
    end
  end
  def sortPlaces(places)
    allPlaces.sort_by! do |hsh|
      if @checkinScreen
        @sort = :order_distance
      end
      if hsh[@sort].nil?
        0
      else
        hsh[@sort]
      end
    end
    if @sort == :checkins
      allPlaces.reverse!
    end
  end
  def update
    hideNullMsg
    @places = []
    @lastClosest = 9999999
    @closest = false
    if @position
      processPositions(allPlaces)
      sortPlaces(allPlaces)
    end
    allPlaces.each do |place|
      if place[:place_type].to_s == @type.to_s || @type.to_i == 0 || (@type.to_i == 999 && isPicked(place))
        if @checkinScreen
          puts '>>> '
          puts 'CHECKIN SCREEN'
          if place[:order_distance].to_i < 750
            @places << make_cell(place)
          end
        else
          @places << make_cell(place)
        end
      elsif @type.to_i == 998
        pl_evs = []
        events = Assets.get("events")
        events.each do |event|
          if !event[:what].nil? && !event[:lat].nil? && !event[:lon].nil? && !event[:address].nil?
            place = {
              place_id: event[:event_id],
              type: 998,
              name: event[:what],
              address: event[:address],
              lat: event[:lat],
              lon: event[:lon]
            }
            pl_evs << place
          end
        end
        processPositions(pl_evs)
        puts 'DONE PROCESSING'
        puts pl_evs
        sortPlaces(pl_evs)
        puts "SORTED"
        pl_evs.each do |ev|
          @places << make_cell(ev)
        end
      end
    end
    if @places.length == 0 && @checkinScreen
      showNullMsg
    end
    update_table_data
    UIView.setAnimationsEnabled false
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled true
  end
  def showNullMsg
    hideNullMsg
    frame = self.tableView.frame
    @nullHead = UILabel.alloc.initWithFrame [[0, 100], [frame.size.width, 40]]
    @nullHead.text = "You're not near any venues."
    @nullHead.font = Font.Vitesse_Medium(18)
    @nullHead.textColor = Color.dark_gray
    @nullHead.textAlignment = NSTextAlignmentCenter
    @nullMsg = UITextView.alloc.initWithFrame [[20, 130], [frame.size.width-40, 80]]
    @nullMsg.text = "When you're in Portland and near one of our suggested locations, you can check in to it here."
    @nullMsg.font = Font.Karla_Bold(15)
    @nullMsg.editable = false
    @nullMsg.textColor = Color.dark_gray
    @nullMsg.textAlignment = NSTextAlignmentCenter
    @nullMsg.backgroundColor = Color.clear
    self.tableView.addSubview @nullHead
    self.tableView.addSubview @nullMsg
  end
  def hideNullMsg
    unless @nullHead.nil?
      @nullHead.removeFromSuperview
      @nullMsg.removeFromSuperview
    end
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.tableView(table_view, cellForRowAtIndexPath:index_path)
    height = cell.getHeight
    height.to_f
  end
end