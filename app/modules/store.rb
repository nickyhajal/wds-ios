module Store
  class << self
    defined? KeyVal
    def get(key, parseJSON = false, cache = false)
      val = false
      if cache
        val = get_cache key
      end
      unless val
        kv = getKV(key)
        if kv
          if parseJSON
            val = BW::JSON.parse(kv.val)
          else
            val = kv.val
          end
        else
          val = false
        end
      end
      val
    end
    def getKV(key)
      # CLSLog("Store key: %@", key)
      # CLSLogv("Store key: %@", va_arg[key])
      # Crashlytics.sharedInstance.setObjectValue(key, forKey: 'storeKey')
      kv = KeyVal.where(key:key)
      # CLSLog("Store response: %@", kv)
      # Crashlytics.sharedInstance.setObjectValue(kv, forKey: 'kvReturnObj')
      # NSLog "%@", kv.inspect
      if !kv.nil? && !kv.count.nil? && kv.count > 0
        kv.first
      else
        if kv.nil? || kv.count.nil?
        end
        false
      end
    end
    def set(key, val, gen_json = false, cache = false)
      if cache
        set_cache key, val
      end
      kv = getKV(key)
      if gen_json
        val = BW::JSON.generate(val)
      end
      if kv
        kv.val = val
      else
        kv = KeyVal.new
        kv.key = key
        kv.val = val
      end
      kv.save
    end
    def set_cache(key, val)
      @cache = {} if @cache.nil?
      @cache[key] = val
    end
    def get_cache(key)
      if !@cache.nil? && !@cache[key].nil?
        @cache[key]
      else
        false
      end
    end
  end
end