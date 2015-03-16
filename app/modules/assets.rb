module Assets
  class << self
    def init
      @assets = ['me','events','interests','speakers','places']
      @expires = {
        'me' => 0,
        'events' => 5,
        'interests' => 300,
        'speakers' => 300,
        'places' => 300
      }
      @aliases = {
        "schedule" => "events",
        "meetups" => "events"
      }
    end
    def sync(&block)
      pull @assets, do
        block.call
      end
    end
    def pull(assets, &block)
      unless assets.kind_of?(Array)
        assets = assets.split(',')
      end
      Api.get 'assets', {tracker: tracker, assets: assets.join(','),via:'ios'} do |rsp|
        rsp = rsp['json']
        assets.each do |asset|
          unless rsp.nil? || rsp[asset].nil?
            if self.respond_to? 'process_'+asset
              self.send('process_'+asset, rsp[asset])
            else
              set asset, rsp[asset]
            end
          end
        end
        unless block.nil?
          block.call
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
      BW::JSON.parse(Store.get(asset))
    end
    def set(asset, val)
      Store.set(asset, BW::JSON.generate(val))
      track(asset)
    end
    def tracker(parse = false)
      tracker = Store.get('tracker')
      tracker = '{}' unless tracker
      if parse
        tracker = BW::JSON.parse(tracker)
      end
      tracker
    end
    def track(asset)
      _tracker = tracker(true)
      _tracker[asset] = NSDate.new.timeIntervalSince1970.floor
      Store.set('tracker', BW::JSON.generate(_tracker))
    end
    def process_me(me)
      Me.update(me)
    end
    def process_events(events)
      schedule = []
      meetups = {}
      lastDay = ''
      events.sort! {|x, y| x['start'] <=> y['start']}
      events.each do |event|
        event = Event.new(event)
        if Me.isAttendingEvent(event)
          unless lastDay == event.startDay
            title = Event.new({type:'title', dayStr:event.dayStr}).to_hash
            schedule << title
            lastDay = event.startDay
          end
        schedule.push event.to_hash
        end
        if event.type == 'meetup'
          if meetups[event.startDay].nil? 
            meetups[event.startDay] = []
          end
          meetups[event.startDay] << event.to_hash
        end
      end
      set 'events', events
      set 'meetups', meetups
      set 'schedule', schedule
    end
  end
end