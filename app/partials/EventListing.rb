class EventListing < PM::TableScreen
  title "EventList"
  attr_accessor :state, :events, :dayStr, :controller
  row_height 144
  def on_load
    @events = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
    days = Assets.get('days')
    @day ||= begin
      days[0][:startDay]
    end
    @dayStr ||= begin
      days[0][:dayStr]
    end
    @state = 'browse'
    @type = 'all'
  end
  def setLayout(layout)
    @layout = layout
  end
  def setDay(day, dayStr)
    @day = day
    @dayStr = dayStr
  end
  def setType(type)
    @type = type
  end
  def setState(state)
    @state = state
  end
  # def scrollToHour
  #   today = NSDate.new.string_with_format(:ymd)
  #   now = NSDate.new.string_with_format(:iso8601).sub(" ", "T")+"Z"
  #   # today = '2015-07-10'
  #   # now = "2015-07-10T12:39:28.067Z"
  #   count = 0
  #   found = 0
  #   section = 0
  #   if (today == @day)
  #     if @events.length > 0
  #       @events.each do |event|
  #         if (section != event[:section])
  #           section = event[:section]
  #           count += 1
  #         end
  #         start = event[:cells][0][:arguments][:event].start
  #         if start > now
  #           found = count
  #           break
  #         end
  #       end
  #       0.1.seconds.later do
  #         self.tableView.scrollToRowAtIndexPath(NSIndexPath.indexPathForRow(0, inSection: found), atScrollPosition: UITableViewScrollPositionTop, animated: true)
  #       end
  #     end
  #   end
  # end
  def table_data
    @events
  end
  def make_cell(event)
    @width ||= begin
      @layout.super_width
    end
    event = Event.new(event)
    if @state != 'suggested'
      event.because = nil
      event.becauseStr = nil
    end
    {
      title: '',
      cell_class: EventCell,
      arguments: { event: event },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        event: event,
        width: @width,
        controller: @controller
      }
    }
  end
  def update_events(events, scrollToTop = true)
    events[@day] = [] if events[@day].nil?
    tmp = events[@day]
    use = []
    filtered = []
    byDay = {}
    final = []
    if @state == 'attending'
      tmp.each do |event|
        if Me.isAttendingEvent(Event.new(event))
          use << event
        end
      end
    elsif @state == 'suggested'
      tmp.each do |event|
        interested = Me.isInterestedInEvent(Event.new(event))
        if interested.length > 0
          event['because'] = interested
          use << event
        end
      end
    else
      use = tmp
    end
    if @type == 'all'
      filtered = use
    else
      use.each do |event|
        if event['format'] == @type
          filtered << event
        end
      end
    end
    filtered.each do |event|
      if byDay[event['startStr']].nil?
        byDay[event['startStr']] = []
      end
      byDay[event['startStr']] << make_cell(event)
    end
    section = 0
    byDay.each do |key, val|
      day = {}
      day[:cells] = val
      day[:title] = key
      day[:section] = section
      day[:title_view] = EventSectionHeading
      final << day
      section += 1
    end
    @events = final
    update_table_data
    # http://stackoverflow.com/questions/19268630/ios-trigger-single-cell-tableviewheightforrowatindexpath
    UIView.setAnimationsEnabled false
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled true
    if scrollToTop
      self.tableView.setContentOffset(CGPointMake(0, -self.tableView.contentInset.top), animated: false)
    end
  end
  def scrollViewDidScroll(scrollView)
    @lastY = scrollView.contentOffset.y if @lastY.nil?
    @initialY = scrollView.contentOffset.y if @initialY.nil?
    @lastDir = '' if @lastDir.nil?
    y = scrollView.contentOffset.y
    diff = y - @lastY
    if diff > 0
      dir = 'down'
    elsif diff < 0
      dir = 'up'
    end
    if @lastDir != dir
      @initialY = y
    end
    if y > 50 && (scrollView.contentSize.height - scrollView.bounds.size.height - y) > 50
      if dir == 'up' && (y - @initialY) < 5
        @layout.slide_down
      end
      if dir == 'down' && (y - @initialY) > 5
        @layout.slide_up
      end
    end
    @lastY = scrollView.contentOffset.y
    @lastDir = dir
  end
  def tableView(table_view, viewForHeaderInSection: index)
    section = promotion_table_data.section(index)
    view = section[:title_view]
    view = section[:title_view].new if section[:title_view].respond_to?(:new)
    view.setFont Font.Vitesse_Medium(14)
    view.setBackgroundColor "#F2F2EA".uicolor
    view.setTextColor "#848477".uicolor
    view.text = section[:title].upcase
    view
  end
  def tableView(table_view, heightForHeaderInSection: index)
    24
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.tableView(table_view, cellForRowAtIndexPath:index_path)
    height = cell.getHeight
    height.to_f
  end
end