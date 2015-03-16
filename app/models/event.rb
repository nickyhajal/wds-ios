class Event
  attr_accessor :event_id, :what, :place, :descr, :start, :end, :note, :hosts, :lat, :lon, :who, :active, :ignored, :num_rsvps, :startTime, :startDay, :startStr, :dayStr, :endTime, :type, :ints
  def initialize(event)
    event.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end
  end
  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end
