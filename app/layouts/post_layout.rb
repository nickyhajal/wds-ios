class PostLayout < MK::Layout
  def setController(controller)
    @controller = controller
    @media = false
    @kb_height = 0
  end
  def layout
    root :main do
      add UIView, :input_area do
        add UIImageView, :dots
        add UIImageView, :avatar
        add UITextView, :input do
          add UILabel, :placeholder
          get(:input).layoutIfNeeded
        end
      end
      add UIButton, :cancel
      add UIButton, :camera
      add UIButton, :post
      add UIView, :mediaShell do
        add UIImageView, :mediaImg
        add UIButton, :closeMedia
      end
      add UIView, :loadBase do
        add UIView, :loadProg
      end
      add UIView, :bottomLine
      add UIView, :modal_overlay do
        add UIView, :modal_box do
          add UIButton, :camera_btn
          add UIView, :sep
          add UIButton, :photoroll_btn
        end
      end
    end
  end
  def open_modal
    main = get(:modal_overlay)
    container = get(:modal_box)
    open_a_modal(main, container)
  end
  def close_modal
    main = get(:modal_overlay)
    container = get(:modal_box)
    close_a_modal(main, container)
  end
  def setMedia(id, image)
    @media = id
    get(:loadBase).setHidden true
    get(:mediaImg).setImage image
    reapply!
  end
  def setProgress(prog)
    w = 240 * prog
    @progressW.equals(w)
    get(:loadBase).setHidden false
  end
  def clearMedia
    @media = false
    updatePostButton
    @controller.clearMedia
    reapply!
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def modal_overlay_style
    backgroundColor Color.tan(0.7)
    target.on_tap do
      close_modal
    end
    hidden true
    constraints do
      left 0
      top 0
      bottom 0
      right 0
    end
  end
  def modal_box_style
    backgroundColor Color.white
    constraints do
      width (super_width * 0.75)
      center_x.equals(:superview)
      top 130
      height 116
    end
  end
  def camera_btn_style
    backgroundColor Color.clear
    titleColor Color.orange
    font Font.Karla_Bold(17)
    title "Take a Picture"
    target.on_tap do
      @controller.camera_action
      close_modal
    end
    constraints do
      top 0
      height 58
      left 0
      right 0
    end
  end
  def sep_style
    backgroundColor Color.orangish_gray(0.3)
    constraints do
      height 1
      width.equals(:superview)
      top.equals(:camera_btn, :bottom)
      left 0
    end
  end
  def photoroll_btn_style
    backgroundColor Color.clear
    titleColor Color.orange
    font Font.Karla_Bold(17)
    title "Choose From My Photos"
    target.on_tap do
      @controller.photoroll_action
      close_modal
    end
    constraints do
      top 59
      height 58
      left 0
      right 0
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
  def closeMedia_style
    title "x"
    font  Font.Karla_Bold(15)
    backgroundColor Color.orange
    titleColor Color.white
    target.on_tap do
      clearMedia
    end
    constraints do
      width 27
      height 27
      right(-38)
      top 0
    end
    layer do
      corner_radius 12
    end
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
  def camera_style
    backgroundColor Color.clear
    target.on_tap do
      open_modal
    end
    target.setImage("camera".uiimage, forState:UIControlStateNormal)
    constraints do
      right.equals(:post, :left).minus(16)
      top 28
      height 20
      width 25
    end
    reapply do
      if @media
        hidden true
      else
        hidden false
      end
    end
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
      top 0
      left 50
      width.equals(:superview).minus(60)
      bottom.equals(:mediaShell, :top)
    end
  end
  def loadBase_style
    backgroundColor Color.orange(0.3)
    hidden true
    constraints do
      center_x.equals(:superview)
      width 240
      height 6
      center_y.equals(:dots)
    end
    layer do
      corner_radius 3
    end
  end
  def loadProg_style
    backgroundColor Color.orange
    constraints do
      center_x.equals(:superview)
      @progressW = width 0
      height 6
      center_y.equals(:dots)
    end
    layer do
      corner_radius 3
    end
  end
  def mediaShell_style
    backgroundColor Color.clear
    constraints do
      left 0
      @mediaB = bottom.equals(:bottomLine, :top).minus(4)
      width.equals(:superview) 
      @mediaH = height 156
    end
    reapply do
      if @media
        hidden false
        @mediaH.equals(96)
      else
        hidden true
        @mediaH.equals(0)
      end
    end
  end
  def dots_style
    elm = target
    elm.setImage "gray_dots.png".uiimage
    contentMode UIViewContentModeScaleAspectFit
    constraints do
      left 0
      bottom.equals(:bottomLine, :top).minus(4)
      width.equals(:superview) 
      height 156
    end
  end
  def mediaImg_style
    elm = target
    elm.setImage "shake.png".uiimage
    contentMode UIViewContentModeScaleAspectFit
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height.equals(:superview)
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
  def bottomLine_style
    backgroundColor Color.clear
    constraints do
      @bottomH = height 0
      bottom 0
      left 0
      width.equals(:superview)
    end
    reapply do
      @bottomH.equals(@kb_height)
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
  def moveInput(notification, dir = false)
    info = notification.userInfo
    kbFrame = info[:UIKeyboardFrameEndUserInfoKey].CGRectValue
    @kb_height = kbFrame.size.height
    reapply!
  end
  def open_a_modal(main, container)
    main.setHidden false
    main.fade_out(0)
    container.fade_out(0)
    main.setHidden false
    main.fade_in(duration: 0.1,
      delay: 0,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 1.0
    )
    container.fade_in(duration: 0.1,
      delay: 0.1,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 1.0
    )
  end
  def close_a_modal(main, container)
    main.fade_out(duration: 0.1,
      delay: 0.1,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 0.0
    )
    container.fade_out(duration: 0.1,
      delay: 0.0,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 0.0
    )
    0.3.seconds.later do
      main.setHidden true
    end
  end 
end