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
    [{cells: @places}]
  end
  def make_cell(place)
    height = calcCellHeight(place)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    {
      title: '',
      cell_class: PlaceCell,
      arguments: { place: place},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        place: place,
        height: height,
        onPicked: (@type.to_i == 999),
        checkinScreen: @checkinScreen,
        width: @width,
        controller: @controller
      }
    }
  end
  def isPicked(place)
    !place[:pick].nil? && place[:pick].length > 0
  end
  def processPositions()
    @allPlaces.each do |place|
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
  def sortPlaces()
    @allPlaces.sort_by! do |hsh|
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
      @allPlaces.reverse!
    end
  end
  def update_items(soft_update = false)
    hideNullMsg
    @places = []
    @lastClosest = 9999999
    @closest = false
    if @position
      processPositions()
      sortPlaces()
    end
    @allPlaces.each do |place|
      if place[:place_type].to_s == @type.to_s || @type.to_i == 0 || (@type.to_i == 999 && isPicked(place))
        if @checkinScreen
          if place[:order_distance].to_i < 750
            @places << make_cell(place)
          end
        else
          @places << make_cell(place)
        end
      end
    end
    if @places.length == 0 && @checkinScreen
      showNullMsg
    end
    args = {}
    if soft_update
      cells = []
      visible = self.tableView.visibleCells
      visible.each do |cell|
        cells << self.tableView.indexPathForCell(cell)
      end
      args = {index_paths: cells, animation: false}
    end
    update_table_data args
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
      @nullHead = nil
      @nullMsg = nil
    end
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.promotion_table_data.cell(index_path: index_path)
    cell[:properties][:height]
  end
  def calcCellHeight(place)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    size = self.frame.size
    size.width = @width - 6 - 40
    if @checkinScreen
      size.width -= 80
    end
    size.height = Float::MAX
    metaHeight = 0
    height = 10+10 # Top and bottom padding

    # Name
    @nameStr = place['name'].nsattributedstring({
      NSFontAttributeName => Font.Vitesse_Medium(19),
      UITextAttributeTextColor => Color.blue
    })
    @name = @nameStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    pgraph = NSMutableParagraphStyle.alloc.init
    pgraph.lineBreakMode = NSLineBreakByTruncatingTail
    height += @name.size.height

    # Address
    if !@checkinScreen
      @addrStr = place['address'].gsub(/, Portland[\,]? OR[\s0-9]*/, '').gsub(/, Portland, OR/, '').nsattributedstring({
        NSFontAttributeName => Font.Karla_Bold(17),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.dark_gray
      })
      @addr = @addrStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += 4 + @addr.size.height
    end

    # Meta
    unless place[:distance].nil?
      units = place[:units]
      bits = place[:distance].to_s.split(".")
      str = ""
      if units == 'ft'
        str = bits[0]
      else
        unless bits[1].nil?
          str = bits[0]+"."+bits[1][0..2]
        end
      end
      str = str+" "+place[:units]+" away"
      if place[:checkins] && !@checkinScreen
        str+= ' - ' + place[:checkins].to_s+' WDSers there now'
      end
      @metaStr = str.nsattributedstring({
        NSFontAttributeName => Font.Karla_Italic(15),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.dark_gray
      })
      @meta = @metaStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += @meta.size.height+4
    end

    if !place[:pick].nil? && place[:pick].length > 0 && (@type.to_i == 999)
      pickStr = "Picked by " + place[:pick].to_s
      @pickStr = pickStr.nsattributedstring({
        NSFontAttributeName => Font.Karla_Bold(15),
        NSParagraphStyleAttributeName => pgraph,
        UITextAttributeTextColor => Color.green
      })
      @pick = @pickStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height += @pick.size.height+4
    end
    return height
  end
end