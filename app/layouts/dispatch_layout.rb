class DispatchItemLayout < MK::Layout
  view :dispatchContentView
  attr_accessor :dispatchContentList
  def setController(controller)
    @controller = controller
  end
  def updateItem(item)
    @kb_height = 0
    @item = item
    @dispatchContentList.updateItem @item
    self.reapply!
  end
  def init_content_list
    @dispatchContentList = DispatchContentList.new
    @dispatchContentList.controller = @controller
    self.dispatchContentView = @dispatchContentList.view
  end
  def layout
    init_content_list
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UIButton, :header_like
      end
      add dispatchContentView, :content
      add UIView, :comment_box do
        add UIView, :comment_line
        add UITextView, :comment_inp
        add UILabel, :placeholder
        add UIButton, :comment_btn
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.light_tan
  end
  def header_style
    background_color Color.bright_blue
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height Device.x(60, 28)
    end
  end
  def header_back_style
    #target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:Color.light_tan), forState:UIControlStateNormal)
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(16)
    addTarget @controller, action: 'back_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top Device.x(20, 28)
      left 0
      width 38
      height 38
    end
  end
  def header_like_style
    constraints do
      right -6
      top Device.x(22, 28)
      height 31
      width 70
    end
    layer do
      border_color Color.white(0.2).CGColor
      corner_radius 4.0
    end
    reapply do
      if Me.likesFeedItem @item.feed_id
        title "Liked!"
        backgroundColor Color.white(0.05)
        titleColor Color.white(0.9)
        layer do
          border_width 1.0
          border_color Color.white(0.1).CGColor
        end
      else
        backgroundColor Color.clear
        titleColor Color.white
        title "Like"
        layer do
          border_color Color.white(0.2).CGColor
          border_width 1.0
        end
      end
    end
    font Font.Vitesse_Medium(16)
    titleColor Color.light_tan
    target.addTarget @controller, action: 'like_action', forControlEvents:UIControlEventTouchDown
  end
  def content_style
    @dispatchContentList.setWidth(super_width)
    constraints do
      width super_width
      @content_height = height super_height - 58 - 40
      top Device.x(58, 28)
      left 0
    end
  end
  def comment_box_style
    backgroundColor Color.white
    constraints do
      @comment_box_height = height 40
      @comment_box_bottom = bottom 0
      width super_width
      left 0
    end
  end
  def comment_btn_style
    # titleColor Color.white
    titleColor Color.orangish_gray
    backgroundColor Color.clear
    font Font.Karla_Bold(14)
    title "Post"
    alpha 0
    addTarget @controller, action: 'post_comment_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right -6
      width 60
      top 6
      height 28
    end
    layer do
      border_width 1
      border_color Color.orangish_gray(0.5).CGColor
      corner_radius 4.0
    end
  end
  def comment_line_style
    backgroundColor Color.light_gray(0.6)
    constraints do
      width.equals super_width
      height 1
      top 0
      left 0
    end
  end
  def comment_inp_style
    delegate self
    font Font.Karla(15)
    backgroundColor Color.white
    constraints do
      height.equals(:comment_box).minus(10)
      top 7
      width super_width - 72
      left 2
    end
  end
  def placeholder_style
    text "Write a comment..."
    textColor Color.gray
    font Font.Karla(15)
    constraints do
      top 0
      left 6
      width super_width
      height 40
    end
  end
  def updatePlaceholder
    textView = get(:comment_inp)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
  end
  def updatePostButton
    inp = get(:comment_inp)
    btn = get(:comment_btn)
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
  def textViewDidEndEditing(textView)
    updatePlaceholder
    updatePostButton
  end
  def textViewDidChange(textView)
    updatePlaceholder
    updatePostButton
    updateCommentBoxSize(textView)
  end
  def updateCommentBoxSize(textView)
    max = (super_height - @kb_height) * 0.5
    height = textView.contentSize.height+6
    height = 40 if height < 40
    height = max if height > max
    @comment_box_height.equals(height)
  end
  def moveInput(notification, dir = false)
    info = notification.userInfo
    kbFrame = info[:UIKeyboardFrameEndUserInfoKey].CGRectValue
    if info[:UIKeyboardAnimationDurationUserInfoKey].nil?
      duration = 0.25
    else
      duration = info[:UIKeyboardAnimationDurationUserInfoKey].to_f
    end
    if info[:UIKeyboardAnimationCurveUserInfoKey].nil?
      curve = 0
    else
      curve = info[:UIKeyboardAnimationCurveUserInfoKey].to_i << 16
    end
    @kb_height = kbFrame.size.height
    unless dir
      @content_height.equals(super_height - 58 - @kb_height - 40)
      @comment_box_bottom.equals(@kb_height * -1)
      get(:comment_btn).alpha = 1
    else
      @content_height.equals(super_height - 58 - 40)
      @comment_box_height.equals(40)
      @comment_box_bottom.equals(0)
      get(:comment_btn).alpha = 0
    end
    UIView.animateWithDuration(duration, delay: 0.0, options: curve, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end

  ## ScrollView Delegate
  def scrollViewDidScroll(scrollView)
    y = scrollView.contentOffset.y
    if y < -20
     # slideClosed
    end
  end
end