class ScheduleLayout < MK::Layout
  view :schedule_view
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add schedule_view, :schedule
    end
  end
  def schedule_style
    constraints do
      left 0
      right "100%"
      top 64
      height.equals(:superview).minus(64)
    end
  end
  def main_style
    background_color "#000000".uicolor
  end
end  