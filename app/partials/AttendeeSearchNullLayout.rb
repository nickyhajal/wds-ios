class AttendeeSearchNullLayout < MK::Layout
  def layout
    add UIView, :main do
      add UITextView, :null_msg
    end
  end
  def super_width
    self.view.frame.size.width
  end
  def setMsg(str)
    @msg = str
    reapply!
  end
  def main_style
    background_color Color.clear
    constraints do
      width.equals(:superview)
      height.equals(:superview)
      top 0
      left 0
    end
  end
  def null_msg_style
    # hidden true
    editable false
    @msg = "Search WDS Attendees Above"
    always do
      pgraph = NSMutableParagraphStyle.alloc.init
      pgraph.alignment = NSTextAlignmentCenter
      str = @msg.attrd({
        NSFontAttributeName => Font.Vitesse_Medium(17),
        UITextAttributeTextColor => Color.orangish_gray,
        NSParagraphStyleAttributeName => pgraph
      })
      # status = ""
      # str += status.attrd({
      #   NSFontAttributeName => Font.Karla_Italic(14),
      #   UITextAttributeTextColor => Color.orangish_gray,
      #   NSParagraphStyleAttributeName => pgraph
      # })
      attributedText str
    end
    font Font.Vitesse_Medium(17)
    textColor Color.orangish_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    constraints do
      center_x.equals(:superview)
      top 100
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
end