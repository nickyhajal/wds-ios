module Me
  class << self
    attr_accessor :first_name, :last_name, :user_token
    def init(delegate)
      @delegate = delegate
      @user_token = false
      @params = {}
    end
    def sync(&block)
      Assets.pull 'me', &block
    end
    def update(params)
      params.each do |key, val|
        set key, val
      end
    end
    def set(key, val)
      @params[key] = val
    end
    def get(key)
      @params[key]
    end
    def checkLoggedIn
      user_token = KeyVal.where(key: 'user_token')
      if user_token.count > 0
        @user_token = user_token.first.val
        @delegate.open_main_app 
        true
      else
        @delegate.open_login
        false
      end
    end
    def saveUserToken(user_token)
      kv = KeyVal.new
      kv.key = 'user_token'
      kv.val = user_token
      kv.save
      Me.checkLoggedIn
    end
    def isFriend(user_id)
      get('connected_ids').include? user_id
    end
    def isAttendingEvent(event)
      if event.type == 'program'
        true
      else
        get('rsvps').include? event.event_id
      end
    end
  end
end