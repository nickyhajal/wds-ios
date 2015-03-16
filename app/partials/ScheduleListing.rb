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
          title: '',
          cell_class: ScheduleCell,
          action: :show_event_profile_action,
          arguments: { event: event },
          properties: {
            selectionStyle: UITableViewCellSelectionStyleNone,
            event: event
          }
        }
      end
    }]
  end
  def update_events(events)
    @events = events
    update_table_data
  end
end