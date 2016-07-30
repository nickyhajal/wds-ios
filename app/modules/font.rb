module Font
  class << self
    def get(args)
      font = args[0]
      size = args[1]
      font = font.gsub('_', '-')
      puts font
      UIFont.fontWithName(font, size:size)
    end
    def method_missing(name, *args, &block)
      # puts '>> MET MISS'
      # puts name
      unless args.empty?
        args = [name] + args
        self.send('get', args)
      end
    end
  end
end