class AttendeeSearchCell < PM::TableViewCell
  def name=(name)
    @name_view ||= begin
      v = add UILabel.alloc.initWithFrame([[ 47, 7 ], [ 300, 30 ]])
      v.backgroundColor = UIColor.clearColor
      v.textColor = "#EB9622".uicolor
      v.font = Font.Karla_Bold(17)
      v 
    end
    @name_view.text = name
    @name_view
  end
  def avatar=(url)
    @avatar_view ||= begin
      av = add UIImageView.alloc.initWithFrame([[ 7, 7 ], [ 30, 30 ]])
      av
    end
    unless url.include? "http"
      url = 'http://worlddominationsummit.com'+url
    end
    @avatar_view.setImageWithURL(NSURL.URLWithString(url), placeholderImage:UIImage.imageNamed("default-avatar.png"))
    @avatar_view.layer.cornerRadius = 15.0
    @avatar_view.layer.masksToBounds = true
    @avatar_view
  end
end