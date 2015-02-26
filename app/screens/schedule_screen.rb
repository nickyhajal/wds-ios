class ScheduleScreen < PM::Screen
  title "Your Schedule"
  status_bar :light

  def on_load
    @layout = ScheduleLayout.new(root: self.view).build
    true
  end
  def on_init
    set_tab_bar_item system_item: :most_recent
  end
end