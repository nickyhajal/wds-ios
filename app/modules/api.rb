module Api
  ####
  ####
  ####
  #### CHANGE URL BEFORE LIVE
  ####
  ####
  ####
  if Device.simulator?
  #  @@url = 'http://wds.nky/api/'
   @@url = 'https://api.worlddominationsummit.com/api/'
  else
    # @@url = 'https://staging.worlddominationsummit.com/api/'
    @@url = 'https://api.worlddominationsummit.com/api/'
  end
  class << self
    attr_accessor :url
    def init
      @client = AFMotion::Client.build(@@url) do
        header "Accept-Encoding", "gzip"
        response_serializer :json
        request_serializer :json
      end
    end
    def get(path, params, &block)
      puts path
      request('get', path, params, &block)
    end
    def post(path, params, &block)
      puts path
      request('post', path, params, &block)
    end
    def put(path, params, &block)
      puts path
      request('put', path, params, &block)
    end
    def delete(path, params, &block)
      puts path
      request('delete', path, params, &block)
    end
    def postImage(image, &block)
      @client.multipart_post("https://photos.wds.fm/photo") do |result, form_data, progress|
        if form_data
          # Called before request runs
          # see: http://cocoadocs.org/docsets/AFNetworking/2.5.0/Protocols/AFMultipartFormData.html
          form_data.appendPartWithFileData(UIImageJPEGRepresentation(image, 0.3.to_f), name: "photo", fileName:"photo.png", mimeType: "image/jpeg")
        elsif progress
          block.call('progress', progress)
        elsif result.success?
          block.call('success', Response.new(result))
        else
          block.call('fail', false)
        end
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
      # puts rsp.object
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
