class AttendeeSearchCell < PM::TableViewCell
  attr_accessor :width
  def name=(name)
    @name_view ||= begin
      v = add UILabel.alloc.initWithFrame([[ 50, 7 ], [ self.frame.size.width-54-30, 30 ]])
      v.backgroundColor = UIColor.clearColor
      v.textColor = "#EB9622".uicolor
      v.font = Font.Karla_Bold(17)
      v
    end
    @name_view.text = name
    @name_view
  end
  def avatar=(user_id)
    @avatar_view ||= begin
      av = add UIImageView.alloc.initWithFrame([[ 2, 2 ], [ 39, 39 ]])
      av
    end
    url = 'http://avatar.wds.fm/'+user_id.to_s+'?width=105'
    @user_id = user_id
    @avatar_view.setImageWithURL(NSURL.URLWithString(url), placeholderImage:UIImage.imageNamed("default-avatar.png"))
    @avatar_view
  end
  def friend=(show)
    @btn_view ||= begin
      frame = self.frame
      btn = add UIButton.alloc.initWithFrame([[ @width-28-4, 8 ], [ 28, 28]])
      btn.setImage Ion.image(:person_add, color:Color.blue), forState:UIControlStateNormal
      btn.addTarget self, action: 'friend_action', forControlEvents:UIControlEventTouchDown
      btn
    end
    if (show)
      @btn_view.setHidden false
    else
      @btn_view.setHidden true
    end
    @btn_view
  end
  def friend_action
    Me.toggleFriendship @user_id do
      @btn_view.setHidden Me.isFriend(@user_id)
    end
  end
end