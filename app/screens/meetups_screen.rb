class MeetupsScreen < PM::Screen
  title "Meetups"
  status_bar :light
  attr_accessor :layout
  def on_init
    selected = UIImage.imageNamed("meetups_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("meetups_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_nav_bar_button :right, title: "Host", action: 'open_host'
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      title: '  Meetups  '
    })
    self.tabBarItem.titlePositionAdjustment = UIOffsetMake(8, 0)
    @meetup_screen = MeetupScreen.new(nav_bar: false)
  end
  def on_load

    @layout = MeetupsLayout.new(root: self.view)
    @layout.setController self
    @meetup_table = MeetupListing.new
    @meetup_table.controller = self
    @meetup_table.setState 'browse'
    @meetup_table.setLayout @layout
    @layout.meetup_view = @meetup_table.view
    @layout.build
    if @day.nil?
      days = Assets.get('days')
      day = days[0]
      today = NSDate.new
      if today.string_with_format(:ymd) >= '2015-07-07'
        ends = ['th','st','nd','rd','th','th','th','th','th','th']
        dayNum = today.string_with_format("d").to_i
        if (dayNum % 100) >= 11 && (dayNum % 100) <= 13
           dayNum = dayNum.to_s + 'th'
        else
           dayNum = dayNum.to_s + ends[dayNum % 10]
         end
        day = {day: today.string_with_format(:ymd), dayStr: today.string_with_format("EEEE")+", "+today.string_with_format("MMMM")+" "+dayNum}
      end
      setDay(day[:day], day[:dayStr])
    end
    true
  end
  def will_appear
    update_meetups(false)
    checkIfNullState
  end
  def setDay(day, dayString)
    if @day != day
      @day = day
      @meetup_table.setDay day, dayString
      @layout.get(:day_selector).setDay(dayString)
      update_meetups
      @meetup_table.scrollToHour
      checkIfNullState
    end
  end
  def open_host
    @layout.open_host
  end
  def checkIfNullState
    elm = @layout.get(:null_msg)
    dayStr = @meetup_table.dayStr.split(', ')[1]
    state = @meetup_table.state
    if @meetup_table.events.length == 0
      if state == 'attending'
        msg = "You haven't RSVPed to any meetups on "+dayStr+"...yet!"
      elsif state == 'browse'
        msg = "No meetups for "+dayStr+"...yet!"
      elsif state == 'suggested'
        msg = "Join communities for more suggestions."
      end
      elm.text = msg
      elm.hidden = false
    else
      elm.hidden = true
    end
  end
  def open_meetup(meetup, from = false)
    @meetup_screen.setMeetup meetup, from
    open_modal @meetup_screen
  end
  def update_meetups(scrollToTop = true)
    Assets.getSmart 'meetups' do |events, status|
      @meetup_table.update_meetups events, scrollToTop
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
    checkIfNullState
  end
  def shouldAutorotate
    false
  end
end