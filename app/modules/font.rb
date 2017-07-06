module Font

  # Adding a font? Make sure it's in the Rakefile
  class << self
    def get(args)
      font = args[0]
      size = args[1]
      font = font.gsub('_', '-')
      UIFont.fontWithName(font, size:size)
    end
    def method_missing(name, *args, &block)
      unless args.empty?
        args = [name] + args
        self.send('get', args)
      end
    end
  end
end