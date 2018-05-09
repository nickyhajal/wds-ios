module Fire
  class << self
    def init
      FIRApp.configure
      @ref = FIRDatabase.database.reference
    end
    def auth(token, &block)
      # puts token
      FIRAuth.auth.signInWithCustomToken(token, completion: -> user, error {
        NSLog "%@", error
        block.call(user, error)
      })
    end
    # def ref(path)
    #   @ref.setValue()
    #   path = @url+path
    #   Firebase.alloc.initWithUrl(path)
    # end
    def set(path , val)
      @ref.child(path).setValue(val)
    end
    def get(path, &block)
      @ref.child(path).observeSingleEventOfType(FIRDataEventTypeValue, withBlock: block)
    end
    def remove(path)
      @ref.child(path).removeValue()
    end
    def createAt(path)
      @ref.child(path).childByAutoId().key
    end
    def query(type, path, queries, &block)
      single = false
      bits = type.split('-')
      type = bits[0]
      unless bits[1].nil?
        single = true
      end
      ftype = case type
      when 'value'
        FIRDataEventTypeValue
      when 'added'
        FIRDataEventTypeChildAdded
      when 'changed'
        FIRDataEventTypeChildChanged
      when 'removed'
        FIRDataEventTypeChildRemoved
      when 'moved'
        FIRDataEventTypeChildMoved
      end
      ref = @ref.child(path)
      queries.each do |q|
        if q[:type] == 'orderKey'
          ref = ref.queryOrderedByKey()
        end
        if q[:type] == 'orderChild'
          ref = ref.queryOrderedByChild(q[:val])
        end
        if q[:type] == 'limitLast'
          ref = ref.queryLimitedToLast(q[:val])
        end
        if q[:type] == 'startChildAt'
          ref = ref.queryStartingAtValue(q[:val], childKey: q[:child])
        end
      end
      if single
        handle = ref.observeSingleEventOfType(ftype, withBlock: block)
      else
        handle = ref.observeEventType(ftype, withBlock: block)
      end
      return {ref: handle, path: path}
    end
    def watch(type, path, &block)
      ftype = case type
      when 'value'
        FIRDataEventTypeValue
      when 'added'
        FIRDataEventTypeChildAdded
      when 'changed'
        FIRDataEventTypeChildChanged
      when 'removed'
        FIRDataEventTypeChildRemoved
      when 'moved'
        FIRDataEventTypeChildMoved
      end
      ref = @ref.child(path).observeEventType(ftype, withBlock: block)
      return {ref: ref, path: path}
    end
    def unwatch(handle)
      @ref.child(handle[:path]).removeObserverWithHandle(handle[:ref])
    end
  end
end