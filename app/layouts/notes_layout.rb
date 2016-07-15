class NotesLayout < MK::Layout
  view :notes_view
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
      add notes_view, :notes_list
      add UITextView, :null_msg
      add UIView, :note_box do
        add UIView, :note_line
        add UITextView, :note_inp
        add UILabel, :placeholder
        add UIButton, :note_btn
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
    background_color Color.tan
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
    title 'x'
    titleColor Color.white
    font Font.Vitesse_Medium(18)
    addTarget @controller, action: 'close_action', forControlEvents:UIControlEventTouchDown
    constraints do
      top 20
      left 0
      width 38
      height 38
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
    textColor Color.light_tan
    reapply do
      text "Your Notes on "+@atn.first_name
    end
  end
  def null_msg_style
    hidden true
    editable false
    reapply do
      text "Add a note about "+@atn.first_name+" below.\n\nYour attendee notes are private to only you."
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
  def notes_list_style
    backgroundColor Color.tan
    constraints do
      left 0
      width super_width
      @listTop = top 58
      @listHeight = height.equals(:superview).minus(146)
    end
  end
  def note_box_style
    backgroundColor Color.white
    constraints do
      @note_box_height = height 40
      @note_box_bottom = bottom 0
      width super_width
      left 0
    end
  end
  def note_btn_style
    titleColor Color.white
    backgroundColor Color.orange
    font Font.Karla_Bold(14)
    title "Save"
    alpha 0
    addTarget @controller, action: 'post_note_action', forControlEvents:UIControlEventTouchDown
    constraints do
      right 0
      width 60
      top 0
      height 40
    end
  end
  def note_line_style
    backgroundColor Color.light_gray(0.6)
    constraints do
      width.equals super_width
      height 1
      top 0
      left 0
    end
  end
  def note_inp_style
    delegate self
    font Font.Karla(15)
    backgroundColor Color.white
    constraints do
      height.equals(:note_box).minus(10)
      top 7
      width super_width - 72
      left 2
    end
  end
  def placeholder_style
    reapply do
      text "Write a note about "+@atn.first_name+"..."
    end
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
    textView = get(:note_inp)
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
    updateNoteBoxSize(textView)
  end
  def updateNoteBoxSize(textView)
    max = (super_height - @kb_height) * 0.5
    height = textView.contentSize.height+6
    height = 40 if height < 40
    height = max if height > max
    @note_box_height.equals(height)
  end
  def moveInput(notification, dir = false)
    info = notification.userInfo
    kbFrame = info[:UIKeyboardFrameEndUserInfoKey].CGRectValue
    duration = info[:UIKeyboardAnimationDurationUserInfoKey].doubleValue
    curve = info[:UIKeyboardAnimationCurveUserInfoKey].integerValue << 16
    @kb_height = kbFrame.size.height
    unless dir
      @note_box_bottom.equals(@kb_height * -1)
      get(:note_btn).alpha = 1
      get(:null_msg).alpha = 0
    else
      @note_box_height.equals(40)
      @note_box_bottom.equals(0)
      get(:note_btn).alpha = 0
      get(:null_msg).alpha = 1
    end
    UIView.animateWithDuration(duration, delay: 0.0, options: curve, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
end