class EventsScreen < PM::Screen
  title "Meetups"
  status_bar :light
  attr_accessor :layout
  def on_init
    selected = UIImage.imageNamed("meetups_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("meetups_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      title: '  Events  '
    })
    self.tabBarItem.titlePositionAdjustment = UIOffsetMake(8, 0)
    @event_screen = EventScreen.new(nav_bar: false)
    @type = 'meetup'
    @types = {
      meetup: {
        title: 'Meetups',
        single: 'Meetup'
      },
      academy: {
        title: 'Academies',
        single: 'Academy'
      },
      spark_session: {
        title: 'Spark Sessions',
        single: 'Spark Session'
      },
      activity: {
        title: 'Activities',
        single: 'Activity'
      },
    }
    @pluralToType = {
      activities: 'activity',
      meetups: 'meetup',
      spark_sessions: 'spark_session',
      academies: 'academy'
    }
  end
  def on_load
    @meetupType = 'all'
    @layout = EventsLayout.new(root: self.view)
    @cart = CartScreen.new(nav_bar: false)
    @layout.setController self
    @events_table = EventListing.new
    @events_table.controller = self
    @events_table.setState 'browse'
    @events_table.setLayout @layout
    @layout.events_view = @events_table.view
    @layout.build
    if @day.nil?
      setDefaultDay
    end
    true
  end
  def setDefaultDay
    days = Assets.get('days')

    # Set the default day to August 11th, 2016 (Thursday)
    day = days[0]
    days.each do |d|
      if d[:day] == '2016-08-11'
        day = d
      end
    end

    # If we are between the dates of WDS, start showing the current day by default
    today = NSDate.new+10.hours
    if today.string_with_format(:ymd) >= '2016-08-07' && today.string_with_format(:ymd) < '2016-08-16'
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
  def will_appear
    update_events(false)
    checkIfNullState('appear')
  end
  def setType(type)
    type = @pluralToType[type.to_sym]
    @type = type
    @layout.type = @type unless @layout.nil?
    self.title = @types[type.to_sym][:title]
    0.02.seconds.later do
      @layout.type = @type unless @layout.nil?
      if type == 'meetup'
        set_nav_bar_button :right, title: "Host", action: 'open_host'
      else
        set_nav_bar_button :right, title: "", action: 'open_host'
      end
      # setDefaultDay
      unless @events_table.nil?
        @events_table.update_events({}, true)
      end
      update_events
      checkIfNullState('etype')
      @layout.reapply!
    end
  end
  def setDay(day, dayString)
    if @day != day
      @day = day
      unless @events_table.nil?
        @events_table.setDay day, dayString
      end
      @layout.get(:day_selector).setDay(dayString)
      update_events
      #@events_table.scrollToHour
      checkIfNullState('set day')
    end
  end
  def open_host
    @layout.open_host
  end
  def open_confirm(event)
    if event.type == 'academy'
      if !Me.claimedAcademy and @event.hasClaimableTickets
        modal = {
          item: event,
          title: 'Attend this Academy!',
          content: "360 and Connect attendees may claim one complimentary
          academy and purchase additional academies for $29.

Would you like to claim this ticket? (You can't change this later)
          continue.",
          yes_action: 'claimAcademy',
          yes_text: 'Claim Academy',
          no_text: 'No, thanks.',
          controller: self
        }
      else
        modal = {
          item: event,
          title: 'Attend this Academy!',
          content: "WDS Academies cost $59 but 360 and Connect attendees
          can get access for just $29.

Would you like to purchase this academy?",
          yes_action: 'purchaseAcademy',
          yes_text: 'Purchase Academy',
          no_text: 'No, thanks.',
          controller: self
        }
      end
    else
      type = @types[event.type.to_sym][:single]
      typelow = type.downcase
      if Me.isAttendingEvent event
        modal = {
          item: event,
          title: "Can't make it?",
          content: "Not able to make it to this #{typelow}? No problem.

Just cancel your RSVP below to make space for other attendees.
          ",
          yes_action: 'doRsvp',
          yes_text: 'Cancel RSVP',
          controller: self
        }
      else
        modal = {
          item: event,
          title: 'See you there?',
          content: "This #{typelow} will be on #{event.dayStr} at #{event.startStr}.

Please only RSVP if you're sure you will attend.
          ",
          yes_action: 'doRsvp',
          yes_text: 'Confirm RSVP',
          controller: self
        }
      end
    end
    @layout.get(:modal).open(modal)
  end
  def doRsvp(event)
    Me.toggleRsvp event do
      update_events
    end
    @layout.get(:modal).close
  end
  def openAcademy(event)
    slug = event.slug
    url = "https://worlddominationsummit.com/academy/#{slug}".nsurl
    if url.can_open?
      url.open
    end
    @layout.get(:modal).close
  end
  def claimAcademy(event)
    slug = event.slug
    url = "https://worlddominationsummit.com/academy/#{slug}".nsurl
    modal = {
      item: event,
      title: 'Claiming...',
      content: "Hang tight while we claim your ticket...",
      yes_action: 'claimAcademy',
      yes_text: 'Claiming...',
      no_text: 'No, thanks.',
      controller: self
    }
    @layout.get(:modal).open(modal)
    # @layout.get(:modal).close
  end
  def purchaseAcademy(event)
    @cart.setProduct('academy', event)
    open_modal @cart
  end
  def checkIfNullState(from)
    elm = @layout.get(:null_msg)
    dayStr = @events_table.dayStr.split(', ')[1]
    state = @events_table.state
    if @events_table.events.length == 0
      format = ' '
      etype = EventTypes.byId(@type)[:plural].downcase
      if @meetupType != 'all'
        format = " #{@meetupType} "
      end
      if state == 'attending'
        msg = "You haven't RSVPed to any#{format}#{etype} on "+dayStr+"...yet!"
      elsif state == 'browse'
        msg = "No#{format}#{etype} for "+dayStr+"...yet!"
      elsif state == 'suggested'
        msg = "Join communities for more suggestions."
      end
      elm.text = msg
      elm.hidden = false
    else
      elm.hidden = true
    end
  end
  def open_event(event, from = false)
    @event_screen.setEvent event, from
    open_modal @event_screen
  end
  def update_events(scrollToTop = true)
    unless @type.nil?
      Assets.getSmart @type do |events, status|
        events = {} unless events
        @events_table.update_events events, scrollToTop
        checkIfNullState('ue')
      end
    end
  end
  def setMeetupState(state)
    @events_table.setState(state)
    update_events
    checkIfNullState('state')
  end
  def setMeetupType(type)
    @meetupType = type
    @events_table.setType(type)
    update_events
    checkIfNullState('type')
  end
  def shouldAutorotate
    false
  end
end