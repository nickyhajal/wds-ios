module Font

  # Adding a font? Make sure it's in the Rakefile
  class << self
    def get(args)
      # puts UIFont.familyNames.sort
      # puts UIFont.fontNamesForFamilyName 'Graphik App'
      font = args[0]
      size = args[1]
      font = font.gsub('_', '-')
      if font == 'Graphik-Italic'
        font = 'GraphikApp-RegularItalic'
      elsif font == 'Graphik-BoldItalic'
        font = 'GraphikApp-SemiboldItalic'
      end
      if font.include? 'Karla'
        # font = 'Graphik-Medium'
        font = 'Graphik App'
        size -= 1
      end
      if font.include? 'Vitesse'
        # font = 'Graphik-Medium'
        font = 'Produkt App'
        # size += 10
      end
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