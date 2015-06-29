module Color
  class << self
    def get(args)
      color = args[0].to_sym
      if color == :clear
        return UIColor.clearColor
      end
      opacity = args[1].nil? ? 1.0 : args[1]
      colors = {
        orange: [244,149,51],
        tan: "#EAEADC",
        light_tan: "#FCFCFA",
        yellowish_tan: "#F2F2E8",
        bright_tan: "#FCFCF3",
        gray: "#8A8A7D",
        light_gray: "#D8D8D4",
        dark_gray: "#848477",
        orangish_gray: "#B1AEAA",
        blue: "#0A72B0",
        green: "#B0BA1E",
        bright_green: "#BDC72B",
        white: "#FFFFFF",
        coffee: "#21170A"
      }
      colors[color].uicolor(opacity)
    end
    def method_missing(name, *args, &block)
      args = [name] + args
      self.send('get', args)
    end
  end
end

