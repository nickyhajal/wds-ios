class AttendeeSearchCell < PM::TableViewCell
  def name=(name)
    @name_view ||= begin
      v = add UILabel.alloc.initWithFrame([[ 47, 7 ], [ 300, 30 ]])
      v.backgroundColor = UIColor.clearColor
      v.textColor = "#EB9622".uicolor
      v.font = UIFont.fontWithName("Karla-Bold", size:17.0)
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
  # def tableView(table_view, heightForRowAtIndexPath:index_path)
  #   my_cell = self.promotion_table_data.cell(index_path: index_path)
  #   # calculate based on properties
  #   height = my_cell[:some_property] * something else + padding - moon cycle
  #   height.to_f
  # end
end