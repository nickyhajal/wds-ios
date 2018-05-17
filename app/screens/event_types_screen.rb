class EventTypesScreen < PM::Screen
  title "Events"
  status_bar :light
  attr_accessor :layout
  def on_init
    selected = UIImage.imageNamed("meetups_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("meetups_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      # title: '  Events   '
      title: ''
    })
    # self.tabBarItem.titlePositionAdjustment = UIOffsetMake(8, 0)
    @events_screen = EventsScreen.new(nav_bar: true)
  end
  def on_load
    @layout = EventTypesLayout.new(root: self.view)
    @layout.setController self
    @event_table = EventTypesListing.new
    @event_table.controller = self
    @event_table.setLayout @layout
    @layout.event_type_view = @event_table.view
    @layout.build
    true
  end
  def will_appear
    unless @event_table.nil?
      @event_table.update_table_data
    end
  end
  def open_event(item)
    puts item
    @events_screen.setType(item)
    open @events_screen
  end
  def select_event_type_action(sender)
    selector = @layout.get(:subview_selector)
    val = selector.selectedSegmentIndex
    if val == 0
      @meetup_table.setState 'browse'
    elsif val == 1
      @meetup_table.setState 'attending'
    elsif val == 2
      @meetup_table.setState 'suggested'
    end
    checkIfNullState
  end
  def shouldAutorotate
    false
  end
end