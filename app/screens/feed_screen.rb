class FeedScreen < PM::Screen
  title 'Dispatch'
  status_bar :light
  def on_load
    @layout = FeedLayout.new(root: self.view).build
    true
  end
  def on_init
    set_tab_bar_item system_item: :top_rated 
  end
end