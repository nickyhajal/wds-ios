class Interest
  attr_accessor :interest_id, :interest, :members
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
