module Api
  ####
  ####
  ####
  #### CHANGE URL BEFORE LIVE
  ####
  ####
  ####
  @@url = 'http://worlddominationsummit.com/api/'
#  @@url = 'http://wds.nky/api/'
  class << self
    attr_accessor :url
    def get(path, params, &block)
      request('get', path, params, &block)
    end
    def post(path, params, &block)
      request('post', path, params, &block)
    end
    def put(path, params, &block)
      request('put', path, params, &block)
    end
    def delete(path, params, &block)
      request('delete', path, params, &block)
    end
    def request(method, path, params, &block)
      url = @@url + path
      if Me.user_token
        params['user_token'] = Me.user_token
      end
      BubbleWrap::HTTP.send method, url, {payload: params} do |response|
        rsp = {}
        if response.ok?
          json = BW::JSON.parse(response.body.to_str)
          rsp['json'] = json
          rsp['response'] = response
        else
          rsp['err'] = response.status_code
        end
        block.call rsp
      end
    end
  end
end