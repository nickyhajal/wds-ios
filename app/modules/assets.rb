module Assets
  class << self
    def init
      @assets = ['me','events','interests','places', 'slim_attendees']
      @expires = {
        'me' => 0,
        'events' => 5,
        'interests' => 300,
        'places' => 300,
        'slim_attendees' => 300
      }
      @aliases = {
        "schedule" => "events",
        "meetup" => "events",
        "academy" => "events",
        "spark_session" => "events",
        "activity" => "events",
        "expedition" => "events",
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
    def process_slim_attendees(atns)
      Dispatch::Queue.concurrent.async do
        db = fmdb
        db.executeUpdate('DROP TABLE atns');
        # db.executeUpdate("CREATE VIRTUAL TABLE atns USING FTS4(user_id, first_name,  last_name)");
        db.executeUpdate("CREATE TABLE atns (user_id INTEGER PRIMARY KEY, first_name TEXT,  last_name TEXT)");
        puts db.lastErrorMessage
        atns.each do |atn|
          first_name = atn[:first_name]
          last_name = atn[:last_name]
          user_id = atn[:user_id]
          query = "INSERT into atns(user_id,first_name,last_name) VALUES('#{user_id}', '#{first_name}', '#{last_name}')"
          rsp = db.executeUpdate(query);
        end
        db.close
      end
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
      dayData = {}
      reg = {}
      existingDays = {}
      events.sort! {|x, y| [x['start'], x['what']] <=> [y['start'], y['what']]}
      events.each do |event|
        event = Event.new(event)
        type = event.type
        day = event.startDay
        map = {
          'Monday' => 'Mon',
          'Tuesday' => 'Tues',
          'Wednesday' => 'Weds',
          'Thursday' => 'Thurs',
          'Friday' => 'Fri',
          'Saturday' => 'Sat',
          'Sunday' => 'Sun'
        }
        if existingDays[event.startDay].nil?
          existingDays[event.startDay] = true
          dayStr = event.dayStr
          dayName = event.dayStr.split(',')[0]
          dayNameShort = map[dayName];
          dayNum = dayStr.gsub(/[^0-9]/, '')
          dayComplete = {day: event.startDay, dayStr: dayStr, dayName: dayName, dayNameShort: dayNameShort, dayNum: dayNum }
          days << dayComplete
          dayData[dayComplete[:day]] = dayComplete
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
      set 'dayData', dayData
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
    def searchAttendees(q)
      matches = []
      q.split(' ').each do |part|
        matches << searchAtnPart(part)
      end
      mergeSearchScore(matches, 'sorted')
    end
    def searchAtnPart(q)
      fnameMatches = calcMatch('first_name', q, 1)
      lnameMatches = calcMatch('last_name', q, 2)
      mergeSearchScore([fnameMatches, lnameMatches])
    end
    def calcMatch(col, q, baseScore)
      users = {}
      db = fmdb
      q = q.downcase
      res = db.executeQuery("SELECT * FROM atns WHERE #{col} LIKE '%#{q}%'", 2)
      while res.next
        score = baseScore
        colVal = res.stringForColumn(col).downcase
        if (q === colVal)
          score += 2
        elsif colVal.index(q) == 0
          score += 1
        end
        user = {
          user_id: res.intForColumn('user_id'),
          first_name: res.stringForColumn('first_name'),
          last_name: res.stringForColumn('last_name'),
          score: score
        }
        users["u#{user[:user_id]}".to_sym] = user
      end
      db.close
      users
    end
    def mergeSearchScore(sets, sorted = false)
      merged = {}
      sets.each do |set|
        set.each do |key, user|
          if merged[key].nil?
            merged[key] = user
          else
            merged[key][:score] += user[:score]
          end
        end
      end
      if sorted
        toSort = []
        merged.each_value do |user|
          toSort << user
        end
        sorted = (toSort.sort_by { |u| u[:score] })
        sorted.reverse!
        sorted
      else
        merged
      end
    end
    def fmdb
      db = FMDatabase.databaseWithPath(File.join(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0], 'wds.db'))
      if !db.open
        db.release
      end
      db
    end
  end
end
