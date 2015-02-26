class FeedLayout < MK::Layout
  def layout
    root :main do
      add AttendeeSearchTitleLayout, :attendee_search_layout
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def attendee_search_layout_style
    background_color "#B0BA1E".uicolor
    constraints do 
      top 0
      left 0
      width.equals(:superview)
      height 58
    end
  end
end  