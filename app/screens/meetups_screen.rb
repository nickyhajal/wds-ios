class MeetupsScreen < PM::Screen
  title "Meetups"
  status_bar :light

  def on_load
    @layout = MeetupsLayout.new(root: self.view)
    @layout.setController self
    @meetup_table = MeetupListing.new
    @meetup_table.setState 'browse'
    @meetup_table.setLayout @layout
    @layout.meetup_view = @meetup_table.view
    @layout.build
    true
  end
  def will_appear
    update_meetups
  end
  def setDay(day)
    puts day
    @meetup_table.setDay day
    update_meetups
  end
  def update_meetups
    Assets.getSmart 'meetups' do |events, status|
      @meetup_table.update_meetups events
    end
  end
  def change_view_action(sender)
    selector = @layout.get(:subview_selector)
    val = selector.selectedSegmentIndex
    if val == 0
      @meetup_table.setState 'browse'
    elsif val == 1
      @meetup_table.setState 'attending'
    elsif val == 2
      @meetup_table.setState 'suggested'
    end
    update_meetups
  end
end