class ScheduleListing < PM::TableScreen
  title "Schedule"
  row_height 72
  attr_accessor :day, :dayStr, :events, :layout, :controller
  def on_load
    days = Assets.get('days')
    if !days.nil? && days.length > 0
      @day ||= begin
        days[0][:startDay]
      end
      @dayStr ||= begin
        days[0][:dayStr]
      end
      @events = []
      self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    end
  end
  def table_data
    @events
  end
  def setDay(day, dayStr)
    @day = day
    @dayStr = dayStr
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
  #         puts event
  #         if (section != event[:section])
  #           section = event[:section]
  #           count += 1
  #         end
  #         start = event[:cells][0][:arguments][:event]["start"]
  #         puts start
  #         puts now
  #         if start > now
  #           found = count
  #           break
  #         end
  #       end
  #       0.1.seconds.later do
  #         puts found
  #         self.tableView.scrollToRowAtIndexPath(NSIndexPath.indexPathForRow(0, inSection: found), atScrollPosition: UITableViewScrollPositionTop, animated: true)
  #       end
  #     end
  #   end
  # end
  def make_cell(event)
    @width ||= begin
      @layout.super_width
    end
    {
      title: '',
      cell_class: ScheduleCell,
      # action: 'meetup_tap_action',
      arguments: { event: event, width: @width },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        width: @width,
        controller: @controller,
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
      day[:title_view] = EventSectionHeading
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