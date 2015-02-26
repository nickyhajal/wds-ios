class MoreScreen < PM::Screen
  title "More"
  status_bar :light

  def on_load
    @layout = MoreLayout.new(root: self.view).build
    true
  end
  def on_init
    set_tab_bar_item system_item: :more 
  end
end