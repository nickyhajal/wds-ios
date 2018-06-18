module Color
  class << self
    def get(args)
      color = args[0].to_sym
      if color == :clear
        return UIColor.clearColor
      end
      opacity = args[1].nil? ? 1.0 : args[1]
      colors = {
        bright_blue: '#0F54ED',
        light_blue: '#3F76F1',
        dark_gray_blue: '#414958',
        cyan: '#00BFF2',
        orange: "#FD7021",
        gold: "#FEC31F",
        red: "#E74D27",
        dark_tan: "#E2E1DE",
        black: "#000000",
        # orange: [244,149,51],
        tan: "#D4D7DC",
        # tan: "#EAEADC",
        light_tan: "#FCFCFA",
        yellowish_tan: "#F2F2E8",
        dark_yellow_tan: "#D6D6CC",
        bright_tan: "#FCFCF3",
        bright_yellowish_tan: "#FFFFF5",
        gray: "#8A8A7D",
        light_gray: "#D8D8D4",
        dark_gray: "#919CA2",
        # dark_gray: "#848477",
        orangish_gray: "#B1AEAA",
        blue: "#0A72B0",
        green: "#006F3D",
        # green: "#B0BA1E",
        bright_green: "#13AB2E",
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

