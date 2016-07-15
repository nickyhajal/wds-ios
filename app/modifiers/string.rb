class String
  def lcfirst
    self[0, 1].downcase + self[1..-1]
  end
  def ucfirst
    self.gsub(/(\w+)/) { |s| s.capitalize }
  end
end