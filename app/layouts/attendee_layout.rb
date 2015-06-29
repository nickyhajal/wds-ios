class AttendeeLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def updateAttendee(atn)
    @atn = atn
    self.reapply!
    0.05.seconds.later do
      updateScrollSize
    end
  end
  def layout
    root :main do
      add UIView, :header do
        add UIButton, :header_back
      #  add UILabel, :header_name
        add UIButton, :header_friend
      end
      add UIScrollView, :scrollview do
        add UITextView, :name
        add UIView, :line_after_name
        add ButtonList, :connect_buttons
        add UITextView, :about_title
        add HTMLTextView, :about_content
        add UIView, :anchor
      end
      add UIImageView, :dots
      add Avatar, :avatar
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
  def header_name_style
    header_width = (super_width - 170)
    constraints do
      top 20
      left (super_width/2 - header_width/2)
      width header_width
      height 40
    end
    font Font.Vitesse_Medium(16)
    textAlignment UITextAlignmentCenter
    textColor Color.dark_gray
    reapply do
      text @atn.first_name
    end
  end
  def header_back_style
    target.setTitleColor Color.light_tan, forState:UIControlStateNormal
    target.titleLabel.font = Font.Vitesse_Medium(18)
    target.setTitle "x", forState:UIControlStateNormal
    target.setContentEdgeInsets UIEdgeInsetsMake(2, 0, 0, 0)
    addTarget @controller, action: 'back_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 19
      left 0
      width 40
      height 40
    end
  end
  def header_friend_style
    target.setTitleColor Color.light_tan, forState:UIControlStateNormal
    target.titleLabel.font = Font.Vitesse_Bold(15)
    addTarget @controller, action: 'friend_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 28
      right.equals(-6, :right)
      height 24
    end
    reapply do
      txt = "Friend"
      if Me.isFriend(@atn.user_id)
        txt = "unFriend"
      end
      target.setTitle txt, forState:UIControlStateNormal
      target.sizeToFit
    end
  end
  def back_img_style
    image Ion.image(:ios_arrow_back, color:Color.light_tan)
    constraints do
      top 0
      left 0
      width 24
      height 24
    end
  end
  def header_rsvp_style
    constraints do
      right 10
      top 20
      width 100
      height 40
    end
    reapply do
      if Me.isAFriend(@atn)
        title "Friended"
      else
        title "Friend"
      end
    end
    font Font.Vitesse_Medium(16)
    titleColor Color.orange
    target.addTarget @controller, action: 'friend_action', forControlEvents:UIControlEventTouchDown
  end
  def dots_style
    constraints do
      width.equals(:superview).minus(15)
      height 100
      left 5
      top 70
    end
    image "gray_dots.png".uiimage
  end
  def avatar_style
    backgroundColor Color.clear
    reapply do
      img @atn.getPic(512)
    end
    constraints do
      @avatar_width = width 125
      @avatar_height = height 125
      center_x.equals(:superview)
      top 32
    end
  end
  def main_content_style
    constraints do
      @scrollview_top = top 266
      @scrollview_height = height super_height-266
      left 0
      width super_width
    end
  end
  def scrollview_style
    scrollEnabled true
    delegate self
    contentSize [super_width, 900]
    backgroundColor Color.white
    constraints do
      top 60
      height.equals(:superview).minus(60)
      left 0
      width.equals(:superview)
    end
  end
  def name_style
    constraints do
      top 110
      left 15
      @name_height = height 0
      width.equals(:superview).minus(40)
    end
    font Font.Vitesse_Medium(26)
    textColor Color.blue
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor Color.clear
    reapply do
      text @atn.full_name
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @name_height.equals(newSize.height)
    end
  end
  def line_after_name_style
    backgroundColor Color.light_gray
    constraints do
      left.equals(:name)
      width.equals(:name)
      height 6
      top.equals(:name, :bottom).plus(5)
    end
  end
  def connect_buttons_style
    btnList = target
    constraints do
      @button_height = height 0
      width.equals(:name)
      left.equals(:name)
      top.equals(:line_after_name, :bottom).plus(5)
      btnList.setHeightConstraint @button_height
    end
    maxWidth (super_width-20)
    reapply do
      buttons @atn.connect_buttons
    end
  end
  def about_title_style
    constraints do
      top.equals(:connect_buttons, :bottom).plus(25)
      left.equals(:name)
      height 40
      width.equals(:superview).minus(40)
    end
    font Font.Vitesse_Medium(20)
    textColor Color.blue
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor Color.clear
    reapply do
      if @atn.isQna
        text "A bit about "+@atn.first_name
      else
        text ''
      end
    end
  end
  def about_content_style
    constraints do
      top.equals(:about_title, :bottom).minus(12)
      left.equals(:name)
      @about_height = height 40
      width.equals(:superview).minus(40)
    end
    backgroundColor Color.clear
    target.scrollView.scrollEnabled = false
    reapply do
      qna = @atn.qna
      str = qna.attrd({
        NSFontAttributeName => Font.Karla(15)
      })
      rect = str.boundingRectWithSize(CGSizeMake(super_width-40,Float::MAX), options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height = rect.size.height.ceil + 60
      @about_height.equals(height)
      target.setText qna
    end
  end
  def anchor_style
    constraints do
      top.equals(:about_content, :bottom).plus(10)
      height 1
      width.equals(:superview)
      left 0
    end
  end
  def updateScrollSize
    frame = get(:anchor).frame
    bot_padding = 50
    height = frame.origin.y + frame.size.height + bot_padding
    @contentHeight = height
    get(:scrollview).setContentSize([super_width, height])
  end
  def shiftContent(shift)
    @scrollview_top.minus(shift)
    @scrollview_height.plus(shift)
  end

  ## ScrollView Delegate
  def scrollViewDidScroll(scrollView)
    y = scrollView.contentOffset.y
    if y > 0
      if y < 30
        alpha = (30 - y)/30
        get(:dots).setAlpha(alpha)
      else
        get(:dots).setAlpha(0)
      end
      if y < 70
        stroke = (3-(y/70))
        stroke = 2 if stroke < 2
        stroke = 3 if stroke > 3
        get(:avatar).setStroke stroke
        av_size = 125 - y
        @avatar_width.equals(av_size)
        @avatar_height.equals(av_size)
      else
        get(:avatar).setStroke 2
        @avatar_width.equals(55)
        @avatar_height.equals(55)
      end
    else
      size = 125 + (y * -1)
      if size < super_width - 10
        @avatar_width.equals(size)
        @avatar_height.equals(size)
      end
    end
    get(:avatar).setNeedsDisplay
  end
end