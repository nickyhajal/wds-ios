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
    background_color Color.green
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height 60
    end
  end
  def header_back_style
    #target.setImage(Ion.imageByFont(:ios_arrow_back, size:24, color:Color.light_tan), forState:UIControlStateNormal)
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(16)
    addTarget @controller, action: 'back_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 20
      left 0
      width 38
      height 38
    end
  end
  def header_like_style
    constraints do
      right -6
      top 24
    end
    reapply do
      if Me.likesFeedItem @item.feed_id
        title "Liked"
      else
        title "Like"
      end
      get(:header_like).sizeToFit
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
      top 58
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
    titleColor Color.white
    backgroundColor Color.orange
    font Font.Karla_Bold(14)
    title "Post"
    alpha 0
    addTarget @controller, action: 'post_comment_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right 0
      width 60
      top 0
      height 40
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
  def textViewDidEndEditing(textView)
    updatePlaceholder
  end
  def textViewDidChange(textView)
    updatePlaceholder
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
    duration = info[:UIKeyboardAnimationDurationUserInfoKey].doubleValue
    curve = info[:UIKeyboardAnimationCurveUserInfoKey].integerValue << 16
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