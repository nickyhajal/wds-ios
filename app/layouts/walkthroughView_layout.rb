class WalkthroughView < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def layout
    @title = ''
    @content = ''
    @imageName = false
    @imageRatio = 2
    @button = false
    root :main do
      add UIView, :card do
        add UITextView, :title
        add UITextView, :content
        add UIImageView, :icon
        add UIButton, :button
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def setTitle(title)
    @title = title
  end
  def setContent(content)
    @content = content
  end
  def setImage(image)
    @imageName = image
  end
  def setButton(button, target, action)
    @button = button
  end
  def setTransition
    get(:card).setBackgroundColor Color.green
  end
  def main_style
    background_color Color.green
  end
  def card_style
    backgroundColor Color.bright_tan
    constraints do
      center_x.equals(:superview)
      width.equals(:superview).minus(40)
      height.equals(:superview).minus(70)
      top 0
    end
    layer do
      masks_to_bounds true
      corner_radius 4.0
      opaque false
    end
  end
  def title_style
    font Font.Vitesse_Medium(23)
    textColor Color.dark_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    scrollEnabled false
    editable false
    constraints do
      center_x.equals(:superview)
      width.equals(:superview).minus(60)
      top 25
    end
    always do
      target.text = @title
      target.sizeToFit
    end
  end
  def content_style
    font Font.Karla(17)
    textColor Color.dark_gray
    backgroundColor Color.clear
    scrollEnabled false
    textAlignment UITextAlignmentCenter
    editable false
    constraints do
      center_x.equals(:superview)
      width.equals(:superview).minus(40)
      top.equals(:title, :bottom).plus(16)
    end
    always do
      target.text = @content
      target.sizeToFit
    end
  end
  def button_style
    hidden true
    userInteractionEnabled true
    reapply do
      if @button
        hidden false
        title @button
        backgroundColor Color.orange
        titleColor Color.white
        font Font.Karla_Bold(16)
      end
    end
    constraints do
      top.equals(:content, :bottom).plus(20)
      width.equals(:superview).minus(80)
      center_x.equals(:superview)
      height 35
    end
  end
end