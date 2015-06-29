class String
  def lcfirst
    self[0, 1].downcase + self[1..-1]
  end
end