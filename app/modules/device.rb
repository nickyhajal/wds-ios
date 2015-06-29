module Device
  class << self
    def is4
      Device.type == '4'
    end
    def is5
      Device.type == '5'
    end
    def is6
      Device.type == '6'
    end
    def is6p
      Device.type == '6p'
    end
    def type
      width = UIScreen.mainScreen.bounds.size.width
      height = UIScreen.mainScreen.bounds.size.height
      if width > 400
        '6p'
      elsif width > 370
        '6'
      elsif height > 500
        '5'
      else
        '4'
      end
    end
  end
end