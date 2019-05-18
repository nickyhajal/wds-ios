module Me
  class << self
    # defined? KeyVal
    attr_accessor :first_name, :last_name, :user_token, :atn, :fireUser, :firetoken
    def init(delegate)
      @delegate = delegate
      @user_token = false
      @params = {}
      @settings = Store.get('settings', true)
      @settings = {} unless @settings
      me = Store.get('me', true)
      me[:firetoken] = nil if me and !me[:firetoken].nil? and me[:firetoken]
      update me
    end
    def sync(&block)
      Assets.pull 'me', &block
    end
    def update(params)
      if params
        @atn = Attendee.new params
        Crashlytics.sharedInstance().setUserEmail(@atn.email)
        Crashlytics.sharedInstance().setUserName(@atn.full_name)
        params.each do |key, val|
          set key, val
        end
        if !@atn.firetoken.nil? and @atn.firetoken.length > 0
          Fire.auth @atn.firetoken do |user, error|
            fireSet('version/', $VERSION)
            Fire.set('/notifications/'+@atn.user_id.to_s+'/', {})
          end
        end
      end
    end
    def fireSet(path, val)
      Fire.set('/users/'+@atn.user_id.to_s+"/#{path}/", val)
    end
    def set(key, val)
      @params[key] = val
    end
    def get(key)
      @params[key]
    end
    def shouldAutoCheckIn
      if @settings[:auto_checkin].nil?
        true
      else
        @settings[:auto_checkin]
      end
    end
    def setSetting(key, val)
      @settings[key.to_sym] = val
      Store.set('settings', @settings, true)
    end
    def saveDeviceToken(device_token = false)
      token = false
      if device_token
        token = device_token.description.stringByTrimmingCharactersInSet(NSCharacterSet.characterSetWithCharactersInString("<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
        Store.set 'device_token', token
      else
        token = Store.get('device_token')
      end
      if token
        uuid = MCSMApplicationUUIDKeychainItem.applicationUUID
        Api.post 'device', {token: token, uuid: uuid, type: 'ios'} do |rsp|
          puts '>> saved token'
          puts rsp.saved_token
          if rsp.saved_token.to_i > 0
            Store.set('saved_device_token', '1')
          end
        end
      end
    end
    def checkDeviceToken
      saved = Store.get('saved_device_token')
      unless saved
        token = Store.get('device_token')
        if token && !saved
          saveDeviceToken
        end
      end
    end
    def checkLoggedIn
      user_token = KeyVal.where(key: 'user_token')
      if user_token.count > 0
        Api.get 'user/validate', {} do |rsp|
          if rsp.is_err
            @delegate.open_tabs
          else
            if !rsp.json[:valid].nil?
              @user_token = user_token.first.val
              last_version = Store.get('last_version')
              if last_version != $VERSION
                Store.set('last_version', $VERSION)
                # TODO: SHOW VERSION NOTES IF NEW VERSIONS
              end
              @delegate.open_tabs
              true
            else
              @delegate.open_login
              false
            end
          end
        end
      else
        @delegate.open_login
        false
      end
    end
    def checkWalkthrough
      step = Store.get('walkthrough')
      if step
        step.to_i
      else
        0
      end
    end
    def saveUserToken(user_token)
      kv = KeyVal.where(key: 'user_token')
      if kv.count > 0
        kv = kv.first
        kv.val = user_token
      else
        kv = KeyVal.new
        kv.key = 'user_token'
        kv.val = user_token
      end
      kv.save
      Me.checkLoggedIn
    end
    def isFriend(user_id)
      get('connected_ids').include? user_id || Me.atn.user_id.to_i == user_id.to_i
    end
    def hasPermissionForEvent(event)
      (event.for_type == 'all') || (event.for_type == Me.atn.ticket_type)
    end
    def hasSignedUpForRegistration
      hasSignedUp = false
      if Device.simulator?
        @regTimes = [888, 889, 891, 892, 893, 894, 895, 897, 901]
      else
        @regTimes = [651, 771, 772, 773, 774, 775, 776, 778, 781]
      end
      @regTimes.each do |t|
        if get('rsvps').include?(t) || get('rsvps').include?(t.to_s)
          hasSignedUp = true
          break
        end
      end
      hasSignedUp
    end
    def isAttendingEvent(event)
      if event.type == 'program'
        hasPermissionForEvent(event)
      else
        (get('rsvps').include?(event.event_id.to_i)) || (get('rsvps').include?(event.event_id.to_s))
      end
    end
    def likesFeedItem(item_id)
      get('feed_likes').include? item_id
    end
    def isInterested(interest_id)
      get('interests').include? interest_id
    end
    def joinCommunity(interest_id, &block)
      interests = get('interests')
      if Me.isInterested(interest_id)
        Api.delete 'user/interest', {interest_id: interest_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            interests.delete(interest_id)
            set('interests', interests)
          end
          block.call(rsp.members)
        end
      else
        Api.post 'user/interest', {interest_id: interest_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            interests << interest_id
            set('interests', interests)
            block.call(rsp.members)
          end
        end
      end
    end
    def toggleFriendship(atn, &block)
      user_id = atn
      unless atn.is_a? Integer
        user_id = atn.user_id
      end
      return if Me.atn.user_id.to_i == user_id.to_i
      friends = Me.get('connected_ids')
      if Me.isFriend(user_id)
        Api.delete 'user/connection', {to_id: user_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            friends.delete(user_id)
            Me.set('friends', friends)
            block.call
          end
        end
      else
        Api.post 'user/connection', {to_id: user_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            friends << user_id
            Me.set('friends', friends)
            block.call
          end
        end
      end
    end
    def toggleRsvp(event, &block)
      Api.post 'event/rsvp', {event_id: event.event_id} do |rsp|
        if rsp.is_err
          $APP.offline_alert
        else
          rsvps = Me.get('rsvps')
          if Me.isAttendingEvent(event)
            rsvps.delete(event.event_id)
          else
            rsvps << event.event_id
          end
          Me.set('rsvps', rsvps)
          Me.updateSchedule
          block.call
        end
      end
    end
    def addRsvp(event_id)
      rsvps = Me.get('rsvps')
      rsvps << event_id
      Me.set('rsvps', rsvps)
      Me.updateSchedule
    end
    def updateSchedule
      Assets.process_schedule
    end
    def toggleLike(feed_id, &block)
      if !Me.likesFeedItem feed_id
        Api.post 'feed/like', {feed_id: feed_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            feed_likes = Me.get('feed_likes')
            feed_likes << feed_id
            Me.set('feed_likes', feed_likes)
            block.call(rsp.num_likes)
          end
        end
      else
        Api.delete 'feed/like', {feed_id: feed_id} do |rsp|
          if rsp.is_err
            $APP.offline_alert
          else
            feed_likes = Me.get('feed_likes')
            feed_likes.delete(feed_id)
            Me.set('feed_likes', feed_likes)
            block.call(rsp.num_likes)
          end
        end
      end
    end
    def claimedAcademy
      (Me.atn.pre19.nil? || Me.atn.pre19.to_i < 1) || (!Me.atn.academy.nil? and Me.atn.academy.to_i > 0)
    end
    def isInterestedInEvent(event)
      is = Assets.get('interests')
      interested = []
      interests = event.ints
      unless interests.nil?
        my_interests = get('interests')
        interests.each do |int_id|
          if my_interests.include? int_id
            unless isAttendingEvent(event)
              is.each do |i|
                if i['interest_id'] == int_id
                  interested << i['interest']
                end
              end
            end
          end
        end
      end
      interested
    end
  end
end

class Api
  def self.request(method, path, params, &block)
    url = @@url + path
    if Me.user_token
      params['user_token'] = Me.user_token
      params['nopic'] = 1
    end
    unless params[:url].nil?
      url = params[:url] + path
    end
    # puts url
    # puts params.inspect
    # puts params['user_token']
    # puts url puts params

    @client.send method, url, params do |response|
      # puts response.to_s
      block.call Response.new(response)
    end
  end
end

class Assets
    def self.process_me(me)
      Store.set('me', me, true)
      Me.update(me)
    end
    def self.process_events(events)
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
    def self.process_schedule
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