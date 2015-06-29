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
      title: 'Your Schedule'
    })
  end
  def on_load
    @layout = ScheduleLayout.new(root: self.view)
    @schedule_table = ScheduleListing.new
    @layout.schedule_view = @schedule_table.view
    @layout.setController self
    @schedule_table.layout = @layout
    @layout.build
    if @day.nil?
      days = Assets.get('days')
      day = days[0]
      setDay(day[:day], day[:dayStr])
    end
    true
  end
  def will_appear
    update_schedule
    checkIfNullState
  end
  def checkIfNullState
    elm = @layout.get(:null_msg)
    dayStr = @schedule_table.dayStr.split(', ')[1]
    if @schedule_table.events.length == 0
      elm.text = "You don't have anything schedule for "+dayStr+"...yet!"
      elm.hidden = false
    else
      elm.hidden = true
    end
  end
  def setDay(day, dayStr)
    @schedule_table.setDay(day, dayStr)
    update_schedule
    checkIfNullState
  end
  def update_schedule
    Assets.getSmart 'schedule' do |events, status|
      @schedule_table.update_events events
    end
  end
end