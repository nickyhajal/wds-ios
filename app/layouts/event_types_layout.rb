class EventTypesLayout < MK::Layout
  view :event_type_view
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add event_type_view, :event_type_list
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def event_type_list_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      right "100%"
      @listTop = top 58
      if $IS8
        @listHeight = height.equals(:superview).minus(58)
      else
        @listHeight = height.equals(:superview).minus(105)
      end
    end
  end
end