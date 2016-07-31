module Fire
  class << self
    def init
      FIRApp.configure
      @ref = FIRDatabase.database.reference
    end
    def auth(token, &block)
      FIRAuth.auth.signInWithCustomToken(@atn.hash, completion: -> user, error {
        puts user
        puts error
        block.call(user, error)
      })
    end
    # def ref(path)
    #   @ref.setValue()
    #   path = @url+path
    #   Firebase.alloc.initWithUrl(path)
    # end
    def set(path , val)
      set = {}
      set[path] = val
      @ref.setValue(val)
    end
    def get(path, &block)
      ref(path).observeSingleEventOfType(FEventTypeValue, withBlock: block)
    end
    def observe(path, &block)
    end
  end
end