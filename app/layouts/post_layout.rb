class PostLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add UIView, :input_area do
        add UIImageView, :avatar
        add UITextView, :input do
          add UILabel, :placeholder
        end
      end
      add UIButton, :cancel
      add UIButton, :post
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def cancel_style
    title "x"
    titleColor Color.dark_gray
    font Font.Vitesse_Medium(19)
    target.addTarget @controller, action: 'cancel_post_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 6
      top 25
    end
    target.sizeToFit
  end
  def post_style
    title "Post"
    titleColor Color.white
    font Font.Vitesse_Medium(16)
    backgroundColor Color.orange
    target.addTarget @controller, action: 'send_post_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right 0
      top 23
      height 35
      width 80
    end
    target.sizeToFit
  end
  def input_area_style
    backgroundColor Color.white
    constraints do
      top 58
      height.equals(:superview).minus(58)
      width.equals(:superview)
      left 0
    end
  end
  def input_style
    backgroundColor Color.clear
    textColor Color.coffee
    font Font.Karla(15)
    delegate self
    constraints do
      top 6
      left 50
      width.equals(:superview).minus(60)
      height.equals(:superview).minus(16)
    end
  end
  def placeholder_style
    text "Type here to share a post!"
    textColor Color.gray
    font Font.Karla(15)
    constraints do
      top -4
      left 4
      width.equals(:superview)
      height 40
    end
  end
  def avatar_style
    imageWithURL(Me.atn.pic, placeholderImage:"default-avatar.png".uiimage)
    constraints do
      left 6
      top 6
      width 40
      height 40
    end
  end
  def updatePlaceholder
    textView = get(:input)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
  end
  def textViewDidEndEditing(textView)
    updatePlaceholder
  end
  def textViewDidChange(textView)
    updatePlaceholder
  end
end