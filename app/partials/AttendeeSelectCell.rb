class AttendeeSelectCell < PM::TableViewCell
  attr_accessor :width, :controller, :atn
  def name=(name)
    @name_view ||= begin
      v = add UILabel.alloc.initWithFrame([[58, 13], [frame.size.width - 54 - 30, 30]])
      v.backgroundColor = UIColor.clearColor
      v.textColor = '#EB9622'.uicolor
      v.font = Font.Karla_Bold(16)
      v
    end
    @name_view.text = name
    @name_view
  end

  def atn=(attn)
    @atn = attn
    nil
  end
  def avatar=(user_id)
    @avatar_view ||= begin
      av = add UIImageView.alloc.initWithFrame([[10, 10], [34, 34]])
      av
    end
    url = 'https://avatar.wds.fm/' + user_id.to_s + '?width=105'
    @user_id = user_id
    @avatar_view.setImageWithURL(NSURL.URLWithString(url), placeholderImage: UIImage.imageNamed('default-avatar.png'))
    @avatar_view.contentMode = UIViewContentModeScaleAspectFill
    @avatar_view.layer.masksToBounds = true
    @avatar_view.layer.cornerRadius = 17
    @avatar_view
  end

  def selected=(isSelected)
    @btn_view ||= begin
      frame = self.frame
      btn = add UIButton.alloc.initWithFrame([[@width - 24 - 18, 15], [24, 24]])
      btn.backgroundColor = Color.clear
      # btn.layer.cornerRadius = 12
      # btn.layer.borderWidth = 2.0
      btn.on_tap do
        @controller.show_atn_profile_action({ atn: @atn })
      end
      btn
    end
    if isSelected
      @btn_view.setImage UIImage.imageNamed('checked-circle.png'), forState:UIControlStateNormal
      # @btn_view.layer.borderColor = Color.green.CGColor
    else
      @btn_view.setImage UIImage.imageNamed('unchecked-circle.png'), forState:UIControlStateNormal
      # @btn_view.backgroundColor = Color.clear
      # @btn_view.layer.borderColor = "#D8D8C8".uicolor.CGColor
    end
    @btn_view
  end

  def sep=(alwaysTrue)
    @sep ||= begin
      frame = self.frame
      sep = add UIView.alloc.initWithFrame([[0, 53], [@width, 1]])
      sep.backgroundColor = "#848477".uicolor(0.09)
      sep
    end
    @sep
  end

  def friend_action
    Me.toggleFriendship @user_id do
      @btn_view.setHidden Me.isFriend(@user_id)
    end
  end
end
