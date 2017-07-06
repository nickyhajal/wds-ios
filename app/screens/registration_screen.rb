class RegistrationScreen < PM::Screen
  title "Registration"
  status_bar :light
  def on_load
    @layout = RegistrationLayout.new(root: self.view)
    @schedule_table = ScheduleListing.new
    @layout.schedule_view = @schedule_table.view
    @layout.setController self
    @schedule_table.layout = @layout
    @schedule_table.controller = self
    @layout.build
    if @day.nil?
      setDefaultDay
    end
    true
  end
  def setDefaultDay
    days = Assets.get('days')

    # Set the default day to August 11th, 2016 (Thursday)
    day = days[0]
    days.each do |d|
      if d[:day] == '2016-08-11'
        day = d
      end
    end

    # If we are between the dates of WDS, start showing the current day by default
    today = NSDate.new+10.hours
    if today.string_with_format(:ymd) >= '2016-08-09' && today.string_with_format(:ymd) < '2016-08-16'
      ends = ['th','st','nd','rd','th','th','th','th','th','th']
      dayNum = today.string_with_format("d").to_i
      if (dayNum % 100) >= 11 && (dayNum % 100) <= 13
         dayNum = dayNum.to_s + 'th'
      else
         dayNum = dayNum.to_s + ends[dayNum % 10]
       end
      day = {day: today.string_with_format(:ymd), dayStr: today.string_with_format("EEEE")+", "+today.string_with_format("MMMM")+" "+dayNum}
    end
    setDay(day[:day], day[:dayStr])
  end
  def open_event(event)
  end
  def will_appear
    update_schedule
    checkIfNullState
  end
  def checkIfNullState
    elm = @layout.get(:null_msg)
    dayStr = @schedule_table.dayStr.split(', ')[1]
    if @schedule_table.events.length == 0
      elm.text = "No registration times are scheduled for "+dayStr
      elm.hidden = false
    else
      elm.hidden = true
    end
  end
  def setDay(day, dayString)
    if @day != day
      @day = day
      @schedule_table.setDay day, dayString
      @layout.get(:day_selector).setDay(dayString)
      update_schedule
      checkIfNullState
    end
  end
  def update_schedule
    Assets.getSmart 'registration' do |events, status|
      events = {} unless events
      @schedule_table.update_events events
    end
  end
end