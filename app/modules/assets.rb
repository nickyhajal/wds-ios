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
          unless rsp[asset].nil?
            if asset == 'me'
              Me.update(rsp[asset])
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
      existing = get asset
      _tracker = tracker(true)
      diff = (NSDate.new.timeIntervalSince1970 - _tracker[asset].to_i) / 60
      puts diff
      puts @expires[asset]
      doPull = false
      if existing && diff < @expires[asset]
        puts '1'
        block.call existing, 'up-to-date'
      elsif existing
        puts '2'
        block.call existing, 'will-update'
        doPull = true
      else
        puts '3'
        doPull = true
      end
      if doPull
        puts '4'
        pull asset do |rsp|
          puts '5'
          latest_asset = get asset
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
  end
end