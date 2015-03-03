class ScheduleListing < PM::TableScreen
  title "Schedule"
  row_height 72
  def on_load
    @events = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
  end
  def table_data
    [{
      cells: @events.map do |event|
        {
          title: event.what,
          cell_class: ScheduleCell,
          action: :show_event_profile_action,
          arguments: { event: event },
          properties: {
            selectionStyle: UITableViewCellSelectionStyleNone,
            event: event,
            what: event.what
          }
        }
      end
    }]
  end
  def update_events(events)
    @events = processEventsForSchedule(events)
    update_table_data
  end
  def processEventsForSchedule(events)
    filtered = []
    lastDay = ''
    events.sort! {|x, y| x['start'] <=> y['start']}
    events.each do |event|
      event = Event.new(event)
      if Me.isAttendingEvent(event)
        unless lastDay == event.startDay
          title = Event.new({type:'title', start:event.startStr})
          filtered << title
          lastDay = event.startDay
        end
        filtered << event
      end
    end
    filtered
  end
end