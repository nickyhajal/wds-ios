class LoadingLayout < MK::Layout
  def layout
    root :main do
      add UILabel, :heading_label
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def heading_label_style
    text "Loading..."
    textAlignment UITextAlignmentCenter
    constraints do
      top 10
      width.equals(:superview)
      height 20
      left 0
    end
  end
end  