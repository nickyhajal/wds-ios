class EventTypesLayout < MK::Layout
  view :event_type_view
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add event_type_view, :event_type_list
      add UITextView, :null_msg
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def event_type_list_style
    backgroundColor "#F2F2EA".uicolor
    # hidden  true 
    constraints do
      left 0
      right "100%"
      @listTop = top (Device.isX ? 88 : 63)
      bottom.equals(:superview, :bottom)
    end
  end
  def null_msg_style
    hidden true
    editable false
    # text 'Nothing scheduled...yet!'
    textColor Color.gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    paragraphStyle = NSMutableParagraphStyle.alloc.init
    paragraphStyle.lineSpacing = 5
    paragraphStyle.alignment = NSTextAlignmentCenter
    # str = "You'll be able to browse and RSVP to hundreds of events during WDS here soon!".attrd({
    #   NSFontAttributeName => Font.Vitesse_Medium(17),
    #   UITextAttributeTextColor => Color.gray,
    #   NSParagraphStyleAttributeName => paragraphStyle
    # })
    # target.setAttributedText str
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
end