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
          get(:input).layoutIfNeeded
        end
      end
      add UIButton, :cancel
      add UIButton, :post
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
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
    titleColor Color.orangish_gray
    font Font.Karla_Bold(15)
    backgroundColor Color.clear
    target.addTarget @controller, action: 'send_post_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right -4
      top 22
      height 31
      width 80
    end
    layer do
      border_width 1
      border_color Color.orangish_gray(0.5).CGColor
      corner_radius 4.0
    end
    target.sizeToFit
  end
  def input_area_style
    backgroundColor Color.white
    constraints do
      top 58
      height (super_height-58)
      width super_width
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
    get(:input).layoutIfNeeded
  end
  def avatar_style
    imageWithURL(Me.atn.pic, placeholderImage:"default-avatar.png".uiimage)
    contentMode UIViewContentModeScaleAspectFill
    layer do
      masksToBounds true
    end
    constraints do
      left 6
      top 6
      width 40
      height 40
    end
  end
  def updatePostButton
    inp = get(:input)
    btn = get(:post)
    if inp.text.length > 0
      btn.backgroundColor = Color.orange
      btn.titleColor = Color.white
      btn.layer.borderWidth = 0
    else
      btn.backgroundColor = Color.clear
      btn.titleColor = Color.orangish_gray
      btn.layer.borderWidth = 1.0
    end
  end
  def updatePlaceholder
    textView = get(:input)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
    get(:input).layoutIfNeeded
  end
  def textViewDidEndEditing(textView)
    updatePostButton
    updatePlaceholder
  end
  def textViewDidChange(textView)
    updatePostButton
    updatePlaceholder
  end
end