class ScheduleScreen < PM::Screen
  title "Schedule"
  status_bar :light
  def on_load
    @layout = ScheduleLayout.new(root: self.view)
    @schedule_table = ScheduleListing.new
    @layout.schedule_view = @schedule_table.view
    @layout.setController self
    @layout.build
    true
  end
  def will_appear
    update_schedule
  end
  def update_schedule
    Assets.getSmart 'schedule' do |events, status|
      @schedule_table.update_events events
    end
  end
end