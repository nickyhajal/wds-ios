module Assets
  class << self
    def init
      @assets = ['me','events','interests','places']
      @expires = {
        'me' => 0,
        'events' => 5,
        'interests' => 300,
        'places' => 300
      }
      @aliases = {
        "schedule" => "events",
        "meetup" => "events",
        "academy" => "events",
        "spark_session" => "events",
        "activity" => "events",
        "registration" => "events"
      }
    end
    def sync(&block)
      pull @assets, do |rsp|
        block.call rsp
      end
    end
    def pull(assets, &block)
      unless assets.kind_of?(Array)
        assets = assets.split(',')
      end
      Api.get 'assets', {tracker: tracker, assets: assets.join(','),via:'ios'} do |rsp|
        unless rsp.is_err
          assets.each do |asset|
            unless rsp.nil? || rsp[asset].nil?
              if self.respond_to? 'process_'+asset
                self.send('process_'+asset, rsp[asset])
              else
                set asset, rsp[asset]
              end
            end
          end
        end
        unless block.nil?
          block.call rsp.is_err
        end
      end
    end
    def getSmart(asset, &block)
      unaliased = asset
      unless @aliases[asset].nil?
        asset = @aliases[asset]
      end
      existing = get unaliased
      _tracker = tracker(true)
      diff = (NSDate.new.timeIntervalSince1970 - _tracker[asset].to_i) / 60
      doPull = false
      if existing && diff < @expires[asset]
        block.call existing, 'up-to-date'
      elsif existing
        block.call existing, 'will-update'
        doPull = true
      else
        doPull = true
      end
      if doPull
        pull asset do |rsp|
          latest_asset = get unaliased
          block.call latest_asset, 'updated'
        end
      end
    end
    def get(asset)
      asset = Store.get(asset, true, true)
      asset
    end
    def set(asset, val)
      Store.set(asset, val, true, true)
      track(asset)
    end
    def tracker(parse = false)
      tracker = Store.get('tracker', parse)
      unless tracker
        tracker = parse ? {} : '{}'
      end
      tracker
    end
    def track(asset)
      _tracker = tracker(true)
      _tracker[asset] = NSDate.new.timeIntervalSince1970.floor
      Store.set('tracker', _tracker, true)
    end
    def process_me(me)
      Store.set('me', me, true)
      Me.update(me)
    end
    def process_interests(interests)
      Interests.updateInterests(interests)
      set 'interests', interests
    end
    def process_events(events)
      return false unless events
      schedule = {}
      byType = {}
      lastDay = ''
      byDay = {}
      days = []
      reg = {}
      existingDays = {}
      events.sort! {|x, y| [x['start'], x['what']] <=> [y['start'], y['what']]}
      events.each do |event|
        event = Event.new(event)
        type = event.type
        day = event.startDay
        if existingDays[event.startDay].nil?
          existingDays[event.startDay] = true;
          days << {day: event.startDay, dayStr: event.dayStr}
        end
        if Me.isAttendingEvent(event)
          if schedule[event.startDay].nil?
            schedule[event.startDay] = []
          end
          schedule[event.startDay] << event.to_hash
        end
        if byType[type].nil?
          byType[type] = {}
        end
        if byType[type][day].nil?
          byType[type][day] = []
        end
        if Me.hasPermissionForEvent event
          byType[type][day] << event.to_hash
        end
      end
      set 'days', days
      set 'events', events
      byType.each do |type, evs|
        set type, byType[type]
      end
      set 'schedule', schedule
    end
    def process_schedule
      events = get 'events'
      schedule = {}
      lastDay = ''
      byDay = {}
      events.each do |event|
        event = Event.new(event)
        if Me.isAttendingEvent(event)
          if schedule[event.startDay].nil?
            schedule[event.startDay] = []
          end
          schedule[event.startDay] << event.to_hash
        end
      end
      set 'schedule', schedule
    end
  end
end
