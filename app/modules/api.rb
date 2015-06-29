module Api
  ####
  ####
  ####
  #### CHANGE URL BEFORE LIVE
  ####
  ####
  ####
  if Device.simulator?
    @@url = 'http://wds.nky/api/'
    # @@url = 'http://worlddominationsummit.com/api/'
  else
    @@url = 'http://worlddominationsummit.com/api/'
  end
  # @@url = 'http://wds.nky/api/'
  class << self
    attr_accessor :url
    def init
      @client = AFMotion::Client.build(@@url) do
        header "Accept-Encoding", "gzip"
        response_serializer :json
      end
    end
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
        params['nopic'] = 1
      end
      @client.send method, url, params do |response|
        block.call Response.new(response)
      end
    end
  end
end

class Response
  attr_reader :is_err, :err_code, :raw, :json
  def initialize(rsp)
    @raw = rsp
    if rsp.success?
      @is_err = false
      @err_code = false
      @json = rsp.object
      @json.each do |key, value|
        create_attr(key)
        self.send("#{key}=", value)
      end
    else
      @is_err = true
      @err_code = rsp.status_code
    end
    self
  end
  def [](key)
    if @json.nil?
      false
    else
      @json[key]
    end

  end
  def create_method(name, &block)
      self.class.send( :define_method, name, &block )
  end
  def create_attr(name)
    create_method( "#{name}=".to_sym ) do |val|
      instance_variable_set( "@" + name, val)
    end
    create_method( name.to_sym ) do
      instance_variable_get( "@" + name )
    end
  end
  def to_s
    self.inspect
  end
end
