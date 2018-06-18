module Assets
  class << self
    def init
      @assets = ['me','events','interests','places', 'slim_attendees']
      @expires = {
        'me' => 0,
        'events' => 5,
        'interests' => 400,
        'places' => 400,
        'slim_attendees' => 1500
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
      if assetsReady
        puts 'call first ready'
        block.call false
      end
      unless assets.kind_of?(Array)
        assets = assets.split(',')
      end
      Api.get 'assets', {tracker: tracker, assets: assets.join(','),via:'ios'} do |rsp|
        puts 'assets returned'
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
          puts 'call second ready'
          block.call rsp.is_err
        end
      end
    end
    def relativeTime(from, *to)
      just = 40
      if to.kind_of?(Array)
        to = NSDate.new
      end
      diff = (to.timeIntervalSince1970 - from.timeIntervalSince1970)
      if(diff < just)
        return 'just now'
      elsif(diff < 60)
        outDiff = diff.floor
        return "#{outDiff} #{outDiff==1 ? 'second' : 'seconds'} ago"
      elsif(diff < 3600)
        outDiff = (diff/60).floor
        return "#{outDiff} #{outDiff==1 ? 'minute' : 'minutes'} ago"
      elsif(diff < 86400)
        outDiff = (diff/3600).floor
        return "#{outDiff} #{outDiff==1 ? 'hour' : 'hours'} ago"
      else
        outDiff = (diff/86400).floor
        return "#{outDiff} #{outDiff==1 ? 'day' : 'days'} ago"
      end
      return false
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
    def assetsReady
      t = tracker(true)
      return t.has_key?('slim_attendees') && t.has_key?('events')
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
    def process_slim_attendees(atns)
      track('slim_attendees')
      Dispatch::Queue.concurrent.async do
        db = fmdb
        db.executeUpdate('DROP TABLE atns');
        db.executeUpdate("CREATE TABLE atns (user_id INTEGER PRIMARY KEY, first_name TEXT,  last_name TEXT)");
        atns.each do |atn|
          first_name = atn[:first_name].dump
          last_name = atn[:last_name].dump
          user_id = atn[:user_id]
          query = "INSERT into atns(user_id,first_name,last_name) VALUES('#{user_id}', #{first_name}, #{last_name})"
          rsp = db.executeUpdate(query);
        end
        db.close
      end
    end
    def process_interests(interests)
      Interests.updateInterests(interests)
      set 'interests', interests
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
    def preload(image)
      # ref = image.CGImage
      # width = CGImageGetWidth(ref)
      # height = CGImageGetHeight(ref)
      # space = CGColorSpaceCreateDeviceRGB()
      # context = CGBitmapContextCreate(nil, width, height, 8, width * 4, space, KCGBitmapAlphaInfoMask & KCGImageAlphaPremultipliedFirst)
      # CGColorSpaceRelease(space)
      # CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref)
      # CGContextRelease(context)
    end
  end
end
