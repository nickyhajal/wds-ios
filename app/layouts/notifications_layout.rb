class NotificationsLayout < MK::Layout
  view :table
  def setController(controller)
    @controller = controller
  end
  def setAttendee(atn)
    @kb_height = 0
    @atn = atn
  end
  def layout
    @slid_up = false
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
      end
      add table, :notns_list
      add UITextView, :null_msg
      add UITextView, :loading_msg
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.tan
  end
  def header_style
    background_color Color.green
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height Device.x(60, 30)
    end
  end
  def header_back_style
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(18)
    addTarget @controller, action: 'close_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top Device.x(20, 30)
      left 0
      width 38
      height 38
    end
  end
  def header_name_style
    header_width = (super_width - 170)
    constraints do
      top Device.x(20, 30)
      left (super_width/2 - header_width/2)
      width header_width
      height 40
    end
    font Font.Vitesse_Medium(16)
    textAlignment UITextAlignmentCenter
    textColor Color.light_tan
    always do
      text "Notifications"
    end
  end
  def null_msg_style
    hidden true
    editable false
    reapply do
      text "Notifications you receive will appear here!"
    end
    font Font.Vitesse_Medium(17)
    textColor Color.orangish_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
  def loading_msg_style
    hidden true
    editable false
    reapply do
      text "Loading..."
    end
    font Font.Vitesse_Medium(17)
    textColor Color.orangish_gray
    backgroundColor Color.clear
    textAlignment UITextAlignmentCenter
    constraints do
      center_x.equals(:superview)
      top 180
      width.equals(:superview).minus(60)
      height.equals(200)
    end
  end
  def notns_list_style
    backgroundColor Color.tan
    constraints do
      left 0
      width super_width
      @listTop = top Device.x(58, 30)
      bottom.equals(:superview, :bottom)
    end
  end
  def updatePlaceholder
    textView = get(:note_inp)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
  end
end