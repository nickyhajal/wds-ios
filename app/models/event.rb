class Event
  attr_accessor :event_id, :what, :place, :descr, :start, :end, :note, :hosts, :lat, :lon, :address, :who, :active, :ignored, :num_rsvps, :max, :startTime, :startDay, :startStr, :dayStr, :endTime, :type, :ints, :because, :becauseStr
  def initialize(event)
    event.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end
    if self.respond_to?('hosts') && self.hosts[0].is_a?(Hash)
      _hosts = []
      self.hosts.each do |host|
        host = Attendee.new(host)
        _hosts << host
      end
      self.hosts = _hosts
    end
    if self.respond_to?('attendees') && self.attendees[0].is_a?(Hash)
      atns = []
      self.attendees.each do |atn|
        atns << Attendee.new(atn)
      end
      self.attendees = atns
    end
    self.setBecauseStr
  end
  def setBecauseStr
    unless @because.nil?
      str = @because[0,4].join(', ')
      @becauseStr = str.reverse.sub(" ,", " & ").reverse
    end
  end
  def isFull
    @num_rsvps > (@max + (@max * 0.1))
  end
  def to_hash
    hash = {}
    hosts = []
    self.hosts.each do |atn|
      hosts << atn.to_hash
    end
    self.hosts = hosts
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end