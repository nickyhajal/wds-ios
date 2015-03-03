class Event
  attr_accessor :event_id, :what, :place, :descr, :start, :end, :note, :hosts, :lat, :lon, :who, :active, :ignored, :num_rsvps, :startTime, :startDay, :startStr, :endTime, :type
  def initialize(event)
    event.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end
    @startStr = @start
    @start = NSDate.dateWithNaturalLanguageString(@start)
    unless @end.nil?
      @end = NSDate.dateWithNaturalLanguageString(@end)
      @endTime = @end.string_with_format('h:mm a')
    end
    @startTime = @start.string_with_format('h:mm a')
    @startDay = @start.string_with_format(:ymd)
  end
end
