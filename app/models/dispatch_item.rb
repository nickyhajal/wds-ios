class DispatchItem
  attr_accessor :feed_id, :content, :channel_type, :channel_id, :user_id, :num_comments, :num_likes, :created_at, :author, :top_padding, :type, :height, :state, :media, :media_type
  def initialize(event)
    @type = 'item'
    if event == 'default'
      @content = 'Loading'
      @num_comments = '░░'
      @num_likes = '░░'
      @channel_type = 'loading'
      @author = Attendee.new('default')
    elsif !event['type'].nil?
      @type = event['type']
      @height = event['height'] unless event['height'].nil?
      @state = event['state'] unless event['state'].nil?
    else
      @top_padding = 0
      event.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
      if !@first_name.nil? && !@last_name.nil?
        atn = {
          first_name: @first_name,
          last_name: @last_name
        }
        atn[:user_name] = @user_name unless @user_name.nil?
        atn[:user_id] = @user_id
        @author = Attendee.new(atn)
      end
    end
  end
  def mediaUrl
    if !@media.nil? and @media.to_s.length > 0
      "https://photos.wds.fm/media/#{@media}_large"
    else
      false
    end
  end
  def createdTime
    if @created_at.nil?
      'Loading...'
    else
      formatter = NSDateFormatter.alloc.init
      formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      hours = (NSDate.new.utc_offset / 1.hour)
      time = formatter.dateFromString(@created_at).delta(hours:hours)
      Assets.relativeTime(time)
    end
  end
end
