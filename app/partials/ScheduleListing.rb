class ScheduleListing < PM::TableScreen
  title "Schedule"
  row_height 72
  attr_accessor :day, :dayStr, :events, :layout
  def on_load
    days = Assets.get('days')
    @day ||= begin
      days[0][:startDay]
    end
    @dayStr ||= begin
      days[0][:dayStr]
    end
    @events = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
  end
  def table_data
    @events
  end
  def setDay(day, dayStr)
    @day = day
    @dayStr = dayStr
  end
  def make_cell(event)
    @width ||= begin
      @layout.super_width
    end
    {
      title: '',
      cell_class: ScheduleCell,
      action: :meetup_tap_action,
      arguments: { event: event, width: @width },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        width: @width,
        event: event
      }
    }
  end
  def update_events(events)
    UIView.setAnimationsEnabled false
    events[@day] = [] if events[@day].nil?
    tmp = events[@day]
    byDay = {}
    final = []
    tmp.each do |event|
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
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled true
    # USE BELOW TO SCROLL TO CORRECT TIME
    self.tableView.setContentOffset(CGPointMake(0, -self.tableView.contentInset.top), animated: false)
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