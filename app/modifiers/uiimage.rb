class UIImage
  
    # Scales an image to fit within a bounds with a size governed by
    # the passed size. Also keeps the aspect ratio.
    # 
    # newSize - the CGSize of the bounds the image must fit within.
    # aspect  - A Symbol stating the aspect mode (defaults: :min)
    #
    # Returns a new scaled UIImage
    def scaleImageToSize(newSize, aspect = :fit)
      scaledImageRect = CGRectZero
  
      aspectRules  = { :fill => :max } # else :min
  
      aspectWidth  = Rational(newSize.width,  size.width)
      aspectHeight = Rational(newSize.height, size.height)
  
      aspectRatio  = [aspectWidth, aspectHeight].send(aspectRules[aspect] || :min)
  
      scaledImageRect.size        = (size.width * aspectRatio).round
      scaledImageRect.size.height = (size.height * aspectRatio).round
  
      scaledImageRect.origin.x = Rational(newSize.width - scaledImageRect.size.width, 2.0).round
      scaledImageRect.origin.y = Rational(newSize.height - scaledImageRect.size.height, 2.0).round
  
      UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
      drawInRect(scaledImageRect)
      scaledImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      scaledImage
    end
  
  end