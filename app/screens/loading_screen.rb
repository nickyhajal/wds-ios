class LoadingScreen < PM::Screen
  status_bar :light
  def on_load
    @layout = LoadingLayout.new(root: self.view).build
    true
  end
  def shouldAutorotate 
    false 
  end
end