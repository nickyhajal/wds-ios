class ExploreScreen < PM::Screen
  title "Explore"
  status_bar :light

  def on_load
    @layout = ExploreLayout.new(root: self.view).build
    true
  end
  def on_init
    set_tab_bar_item item: :search, title: "Explore"
  end
end