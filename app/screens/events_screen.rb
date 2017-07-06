class EventsScreen < PM::Screen
  title "Meetups"
  include EventModule
  status_bar :light
  attr_accessor :layout
  def on_init
    selected = UIImage.imageNamed("meetups_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("meetups_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      # title: '  Events  '
      title: ''
    })
    # self.tabBarItem.titlePositionAdjustment = UIOffsetMake(8, 0)
    @event_screen = EventScreen.new(nav_bar: false)
    @type = 'meetup'
  end
  def on_load
    @meetupType = 'all'
    @layout = EventsLayout.new(root: self.view)
    @layout.setController self
    @events_table = EventListing.new
    @events_table.controller = self
    @events_table.setState 'browse'
    @events_table.setLayout @layout
    @layout.events_view = @events_table.view
    @layout.build
    @openedDay = false
    true
  end
  def will_appear
  end
  def setDefaultDay(events = false)

    eventStart = NSDate.from_components(year: 2017, month: 7, day: 11)
    if @openedDay
      selected = dayFromShort(@openedDay)
      day = formatDay(selected)
      @openedDay = false
    elsif @tappedDay.nil?
      days = Assets.get('days')

      # Set the default day to July 11th, 2017
      selected = eventStart
      day = days[0]
      days.each do |d|
        if d[:day] == '2017-07-11'
          day = d
        end
      end

      # If we are between the dates of WDS, start showing the current day by default
      selected = NSDate.new+10.hours
      if selected.string_with_format(:ymd) >= '2017-07-11' && selected.string_with_format(:ymd) < '2017-07-18'
        day = formatDay(selected)
      end
    else
      selected = @tappedDay
      day = formatDay(selected)
    end

    if events
      count = 0
      while events[day[:day]].nil? || events[day[:day]].length < 1 do
        selected = selected+24.hours
        day = formatDay(selected)
        count += 1
        if (count > 20)
          selected = eventStart
          day = formatDay(selected)
          count = 0
        end
      end
    end
    @layout.get(:day_selector).setDay(day[:day])
    setDay(day[:day], day[:dayStr])
  end
  def formatDay(today)
      ends = ['th','st','nd','rd','th','th','th','th','th','th']
      dayNum = today.string_with_format("d").to_i
      if (dayNum % 100) >= 11 && (dayNum % 100) <= 13
         dayNum = dayNum.to_s + 'th'
      else
         dayNum = dayNum.to_s + ends[dayNum % 10]
       end
      {day: today.string_with_format(:ymd), dayStr: today.string_with_format("EEEE")+", "+today.string_with_format("MMMM")+" "+dayNum}
  end
  def will_appear
    update_events(false)
    checkIfNullState('appear')
  end
  def setType(type)
    if !type.nil?
      type = pluralToType[type.to_sym]
      @type = type
      @layout.type = @type unless @layout.nil?
      self.title = types[type.to_sym][:title]
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
  end
  def dayFromShort(day)
    parts = day.split('-')
    NSDate.from_components(year: parts[0].to_i, month: parts[1].to_i, day: parts[2].to_i)
  end
  def setDay(day, dayString, tap = false)
    if tap
      @tappedDay = dayFromShort(day)
    end
    if @day != day
      @day = day
      unless @events_table.nil?
        @events_table.setDay day, dayString
      end
      update_events(true, false)
      #@events_table.scrollToHour
      checkIfNullState('set day')
    end
  end
  def open_host
    @layout.open_host
  end
  def open_confirm(event, cell)
    @activeCell = cell
    modal = confirmModal(event)
    @layout.get(:modal).open(modal)
  end
  def doRsvp(event)
    Me.toggleRsvp event do
      @activeCell.setNeedsDisplay
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
    modal = {
      item: event,
      title: 'Claiming...',
      content: "Hang tight while we claim your ticket...",
      yes_action: 'claimAcademy',
      instant_appear: true,
      yes_text: 'Claiming...',
      no_text: 'No, thanks.',
      controller: self
    }
    @layout.get(:modal).open(modal)
    Api.post "event/claim-academy", {'event_id' => event.event_id} do |rsp|
      modal = {
        item: event,
        title: 'Claimed!',
        content: "Nice, you're Insider Access ticket has been claimed!",
        yes_action: 'closeModal',
        instant_appear: true,
        yes_text: 'Claimed!',
        no_text: ' ',
        controller: self
      }
      @layout.get(:modal).open(modal)
      Me.addRsvp(event.event_id)
      Me.atn.academy = event.event_id
      @activeCell.setNeedsDisplay
      8.seconds.later do
        closeModal
      end
    end
  end
  def closeModal
    @layout.get(:modal).close
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
    @openedDay = @day
    open_modal @event_screen
  end
  def update_events(scrollToTop = true, setDay = true)
    if !@type.nil? && !@events_table.nil?
      Assets.getSmart @type do |events, status|
        events = {} unless events
        if setDay
          setDefaultDay(events)
        end
        @layout.updateDaySelector(events)
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