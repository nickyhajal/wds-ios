class LoadingLayout < MK::Layout
  def layout
    root :main do
      add UIImageView, :loading_image
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def loading_image_style
    _width = get(:main).frame.size.width
    _height = get(:main).frame.size.height

    if Device.is6p
      imgName = "Default-736h@3x.png"
    elsif Device.isX
      imgName = "Default-2436h@3x.png"
    elsif Device.is6
      imgName = "Default-667h@2x.png"
    elsif Device.is5
      imgName = "Default-568h@2x.png"
    else
      imgName = "Default@2x.png"
    end
    image imgName.uiimage
    constraints do
      top 0
      width.equals(:superview)
      height.equals(:superview)
      left 0
    end
  end
end