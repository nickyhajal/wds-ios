class ScheduleScreen < PM::Screen
  title "Schedule"
  status_bar :light
  def on_init
    selected = UIImage.imageNamed("schedule_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("schedule_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      # title: 'Schedule'
      title: ''
    })
  end
  def on_load
    # set_nav_bar_button :right, title: "Registration", action: :open_reg
    @event_screen = EventScreen.new(nav_bar: false)
    @layout = ScheduleLayout.new(root: self.view)
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

    # Set the default day to August 11th, 2016
    day = days[0]
    days.each do |d|
      if d[:day] == '2018-06-26'
        day = d
      end
    end

    # If we are between the dates of WDS, start showing the current day by default
    today = NSDate.new+3.hours
    if today.string_with_format(:ymd) >= '2018-06-26' && today.string_with_format(:ymd) < '2018-07-02'
      ends = ['th','st','nd','rd','th','th','th','th','th','th']
      dayNum = today.string_with_format("d").to_i
      if (dayNum % 100) >= 11 && (dayNum % 100) <= 13
         dayNum = dayNum.to_s + 'th'
      else
         dayNum = dayNum.to_s + ends[dayNum % 10]
       end
      day = {day: today.string_with_format(:ymd), dayStr: today.string_with_format("EEEE")+", "+today.string_with_format("MMMM")+" "+dayNum}
    end
    @layout.get(:day_selector).setDay(day[:day])
    setDay(day[:day], day[:dayStr])
  end
  def open_event(event)
    @event_screen.setEvent(event)
    open_modal @event_screen
  end
  def will_appear
    update_schedule
    checkIfNullState
    if Me.atn.registered.to_i > 0
      set_nav_bar_button :right, title: "", action: :open_reg
    else
      # set_nav_bar_button :right, title: "Registration", action: :open_reg
    end
  end
  def open_reg
    open RegistrationScreen
  end
  def checkIfNullState
    elm = @layout.get(:null_msg)
    dayStr = @schedule_table.dayStr.split(', ')[1]
    if @schedule_table.events.length == 0
      elm.text = "You don't have anything scheduled for "+dayStr+"...yet!"
      elm.hidden = false
    else
      elm.hidden = true
    end
  end
  def setDay(day, dayString, isTap = false)
    if @day != day
      @day = day
      @schedule_table.setDay day, dayString
      update_schedule
      #@schedule_table.scrollToHour
      checkIfNullState
    end
  end
  def update_schedule
    Assets.getSmart 'schedule' do |events, status|
      # puts events
      @schedule_table.update_events events
    end
  end
end