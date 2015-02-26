class MeetupsScreen < PM::Screen
  title "Meetups"
  status_bar :light

  def on_load
    @layout = MeetupsLayout.new(root: self.view).build
    true
  end
end