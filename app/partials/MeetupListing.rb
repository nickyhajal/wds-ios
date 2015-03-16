class MeetupListing < PM::TableScreen
  title "MeetupList"
  row_height 144
  def on_load
    @events = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
    @day = "2014-07-11"
    @state = 'browse'
  end
  def setLayout(layout)
    @layout = layout
  end
  def setDay(day)
    @day = day
  end
  def setState(state)
    @state = state
  end
  def table_data
    @events
  end
  def make_cell(event)
    {
      title: '',
      cell_class: MeetupCell,
      action: :meetup_tap_action,
      arguments: { event: event },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        event: event
      }
    }
  end
  def update_meetups(events)
    tmp = events[@day] 
    use = []
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
    use.each do |event|
      if byDay[event['startStr']].nil?
        byDay[event['startStr']] = []
      end
      byDay[event['startStr']] << make_cell(event)
    end
    byDay.each do |key, val|
      day = {}
      day[:title] = key
      day[:cells] = val
      day[:title_view] = MeetupSectionHeading
      final << day
    end
    @events = final
    update_table_data
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
    if y > 100 && (scrollView.contentSize.height - scrollView.bounds.size.height - y) > 100
      if dir == 'up' && (y - @initialY) < 30
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
    view.setFont UIFont.fontWithName('Vitesse-Medium', size:14.0)
    view.setBackgroundColor "#F2F2EA".uicolor
    view.setTextColor "#848477".uicolor
    view.text = section[:title].upcase 
    view
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.tableView(table_view, cellForRowAtIndexPath:index_path)
    height = cell.getHeight
    height.to_f
  end
end