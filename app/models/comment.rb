class Comment
  attr_accessor :feed_comment_id, :feed_id, :user_id, :comment, :created_at, :author
  def initialize(props)
    props.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end
    if !@first_name.nil? && !@last_name.nil?
      atn = {
        first_name: @first_name,
        last_name: @last_name,
        email: @email
      }
      atn[:user_name] = @user_name unless @user_name.nil?
      atn[:user_id] = @user_id unless @user_id.nil?
      atn[:pic] = @pic unless @pic.nil?
      @author = Attendee.new(atn)
    end
  end
  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
  def createdTime
    if @created_at.nil?
      'Loading...'
    else
      formatter = NSDateFormatter.alloc.init
      formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
      time = formatter.dateFromString(@created_at).delta(hours:NSDate.new.utc_offset/1.hour)
      SORelativeDateTransformer.registeredTransformer.transformedValue(time)
    end
  end
end
