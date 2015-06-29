class CommunityScreen < PM::Screen
  status_bar :dark
  attr_accessor :controller, :layout
  def init_layout
    @layout = CommunityLayout.new(root: self.view)
    @layout.setController @controller
    @layout.build
  end
  def shouldAutorotate
    false
  end
end