class FeedLayout < MK::Layout
  view :results_view
  def setController(controller)
    @controller = controller
  end
  def setResultsTable(table)
    @results_table = table
  end
  def layout
    root :main do
      add AttendeeSearchTitleLayout, :attendee_search_layout
      add results_view, :attendee_results
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def attendee_search_layout_style
    get(:attendee_search_layout).setController self
    get(:attendee_search_layout).setResultsTable @results_table
    background_color "#B0BA1E".uicolor
    constraints do 
      top 0
      left 0
      width.equals(:superview)
      height 58
    end
  end
  def attendee_results_style
    hidden true
    constraints do
      top 58
      left 0
      right "100%"
      height.equals(:superview).minus(58)
    end
  end
end  