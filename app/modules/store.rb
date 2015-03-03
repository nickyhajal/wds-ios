module Store
  class << self
    def get(key)
      kv = getKV(key)
      if kv
        kv.val
      else
        false
      end
    end
    def getKV(key)
      kv = KeyVal.where(key:key)
      if kv.count > 0
        kv.first
      else
        false
      end
    end
    def set(key, val)
      kv = getKV(key)
      if kv
        kv.val = val
      else
        kv = KeyVal.new
        kv.key = key
        kv.val = val
      end
      kv.save
    end
  end
end