class FiltersScreen < PM::Screen
  status_bar :dark
  attr_accessor :controller, :layout
  def init_layout
    @layout = FiltersLayout.new(root: self.view)
    @layout.setController @controller
    @layout.build
  end
  def shouldAutorotate
    false
  end
end