class ChatEditLayout < MK::Layout
  view :table, :chatters_view
  attr_accessor :chattersList, :atnModalBoxHeight
  def setController(controller)
    @controller = controller
  end
  def setResults(results)
    @results = results
  end
  def layout
    @chattersList ||= begin
      ch = ChattersHorizontalList.new
      ch
    end
    @chattersList.setController(@controller)
    self.chatters_view = @chattersList.view
    root :main do
      add UIView, :header do
        add UIButton, :header_back
        add UILabel, :header_name
      end
      add chatters_view, :chatters
      add UIView, :search do
        add UITextField, :input
        add UILabel, :placeholder
        add UIImageView, :search_icon
      end
      add table, :person_list
      add UIView, :modal_overlay do
        add UIView, :modal_box do
          add UIView, :modal_titleShell
          add UITextView, :modal_title
          add UITextView, :modal_content
          add UIView, :modal_inpShell do
            add UITextField, :modal_inp
            add UILabel, :modal_placeholder
          end
          add UIButton, :modal_btn
        end
      end
      add UIView, :atn_modal_overlay do
        add UIView, :atn_modal_box do
          add UIView, :atn_modal_titleShell
          add UIImageView, :atn_modal_av
          add UITextView, :atn_modal_title
          add UIView, :atn_sep
          add UIButton, :atn_leave_btn
          add UIButton, :atn_toggle_admin_btn
        end
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def updateChatters 
    @chatters_height.equals(@controller.chatters.length > 0 ? 64 : 0)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def main_style
    background_color "#E7E7DD".uicolor
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
    always do
      text "Messages"
    end
  end
  def chatters_style
    backgroundColor "#F7F7F1".uicolor
    constraints do
      top 64
      left 0
      right 0
      @chatters_height = height 0
    end
  end
  def search_style
    backgroundColor "#FBFBF6".uicolor
    constraints do
      top.equals(:chatters, :bottom).plus(3)
      left 0
      right 0
      height 42
    end
  end
  def input_style
    textColor Color.orangish_gray
    backgroundColor Color.clear
    attributedPlaceholder NSAttributedString.alloc.initWithString("", attributes:{
      NSForegroundColorAttributeName => Color.white
    })
    font UIFont.fontWithName("Karla", size:15.0)
    target.addTarget self, action:'search_action', forControlEvents:UIControlEventEditingChanged
    target.autocorrectionType = UITextAutocorrectionTypeNo
    delegate self
    constraints do
      top.equals(:search).plus(6)
      left.equals(:search).plus(38)
      width.equals(:superview).minus(15)
      height.equals(:superview).minus(13)
    end
  end
  def placeholder_style
    text "Search attendees to chat with"
    textColor Color.gray(0.8)
    backgroundColor Color.clear
    font Font.Karla(15)
    constraints do
      top.equals(:search).plus(6)
      left.equals(:search).plus(38)
      width.equals(:superview).minus(15)
      height.equals(:superview).minus(13)
    end
    get(:input).layoutIfNeeded
  end
  def search_icon_style
    target.image = Ion.imageByFont(:ios_search_strong, size: 24, color:Color.gray(0.7))
    contentMode UIViewContentModeScaleAspectFill
    constraints do
      top 10
      left 10
      width 20
      height 20
    end
  end
  def person_list_style
    backgroundColor Color.tan
    constraints do
      left 0
      width super_width
      top.equals(:search, :bottom).plus(1)
      bottom.equals(:superview, :bottom)
    end
  end
 
  
  def search_action
      updatePlaceholder(get(:input), get(:placeholder))
      q = get(:input).text
      results = Assets.searchAttendees(q).map { |hash| hash.stringify_keys }
      @results.update_results results
      # @controller.respondToSearch
  end
  def name_action
      updatePlaceholder(get(:modal_inp), get(:modal_placeholder))
  end
  def modal_overlay_style
    backgroundColor Color.tan(0.7)
    target.on_tap do
      close_modal
    end
    hidden true
    constraints do
      left 0
      top 0
      bottom 0
      right 0
    end
  end
  def atn_modal_overlay_style
    backgroundColor Color.tan(0.7)
    target.on_tap do
      close_atn_modal
    end
    hidden true
    constraints do
      left 0
      top 0
      bottom 0
      right 0
    end
  end
  def modal_box_style
    backgroundColor Color.white
    constraints do
      width (super_width * 0.75)
      center_x.equals(:superview)
      top 110
      height 234
    end
  end
  def atn_modal_box_style
    backgroundColor Color.white
    constraints do
      width (super_width * 0.75)
      center_x.equals(:superview)
      top 110
      @atnModalBoxHeight = height 169
    end
  end
  def modal_titleShell_style
    backgroundColor Color.blue
    constraints do
      top 0
      height 53
      left 0
      right 0
    end
  end
  def atn_modal_titleShell_style
    backgroundColor Color.blue
    constraints do
      top 0
      height 53
      left 0
      right 0
    end
  end
  def modal_title_style
    text "Name Your Group!"
    editable false
    backgroundColor Color.clear
    font Font.Vitesse_Bold(18)
    textColor Color.white
    textAlignment NSTextAlignmentCenter
    constraints do
      width.equals(:superview)
      left 0
      height 50
      top 10
    end
  end
  def atn_modal_title_style
    text ""
    editable false
    backgroundColor Color.clear
    font Font.Vitesse_Bold(18)
    textColor Color.white
    constraints do
      width.equals(:superview)
      left.equals(:atn_modal_av, :right).plus(8)
      height 50
      top 10
    end
  end
  def modal_content_style
    text "Set a name for your group! You and everyone in it will see the name that you set."
    backgroundColor Color.clear
    textColor Color.dark_gray
    editable false
    font Font.Karla(14)
    constraints do
      top.equals(:modal_titleShell, :bottom).plus(16)
      left 8
      right -8
      height 48
    end
    target.sizeToFit
  end
  def modal_inpShell_style
    backgroundColor Color.tan(0.7)
    constraints do
      top.equals(:modal_content, :bottom).plus(16)
      height 34
      left 10
      right -10
    end
  end
  def modal_inp_style
    font Font.Karla(14)
    textColor Color.dark_gray
    backgroundColor Color.clear
    target.autocorrectionType = UITextAutocorrectionTypeNo
    target.addTarget self, action:'name_action', forControlEvents:UIControlEventEditingChanged
    delegate self
    constraints do
      top 0
      height.equals(:superview)
      left 10
      right -10
    end
  end
  def modal_placeholder_style
    font Font.Karla(14)
    text 'Set your group name'
    textColor Color.dark_gray
    backgroundColor Color.clear
    constraints do
      top 0
      height.equals(:superview)
      left 10
      right -10
    end
  end
  def modal_btn_style
    backgroundColor Color.orange
    titleColor Color.white
    font Font.Karla_Bold(16)
    title "Let's Go!"
    target.on_tap do
      @controller.start_chat_action(get(:modal_inp).text)
    end
    constraints do
      bottom.equals(:modal_box, :bottom)
      height 48
      left 0
      right 0
    end
  end
  def atn_modal_av_style
    contentMode  UIViewContentModeScaleAspectFill
    constraints do
      width 36
      height 36
      left 9
      top 9
    end
    layer do
      masksToBounds true
      corner_radius 18
      border_width 2.0
      border_color Color.white.CGColor
      shadow_color "#000000".cgcolor
      shadow_radius 12
      shadow_opacity 0.65
      shadow_offset [0,4]
    end
  end
  def atn_leave_btn_style
    backgroundColor Color.clear
    titleColor Color.orange
    font Font.Karla_Bold(17)

    title "Remove from Chat"
    target.on_tap do
      @controller.atn_leave_chat
    end
    constraints do
      top.equals(:atn_modal_titleShell, :bottom)
      height 58
      left 0
      right 0
    end
  end
  def atn_sep_style
    backgroundColor Color.orangish_gray(0.3)
    constraints do
      height 1
      width.equals(:superview)
      top.equals(:atn_leave_btn, :bottom)
      left 0
    end
  end
  def atn_toggle_admin_btn_style
    backgroundColor Color.clear
    titleColor Color.orange
    font Font.Karla_Bold(17)
    title "Add to Admins"
    target.on_tap do
      @controller.atn_toggle_admin
    end
    constraints do
      top.equals(:atn_leave_btn, :bottom)
      height 58
      left 0
      right 0
    end
  end

  # Search field delegate
  def clearSearchInput
    get(:input).text = ''
    updatePlaceholder(get(:input), get(:placeholder))
  end
  def updatePlaceholder(input, placeholder)
    text = input.text
    if text.length > 0
      placeholder.hidden = true
    else
      placeholder.hidden = false
    end
  end
  def textFieldDidBeginEditing(textField)
    if textField == get(:input)
      updatePlaceholder(get(:input), get(:placeholder))
    end
    if textField == get(:modal_inp)
      updatePlaceholder(get(:modal_inp), get(:modal_placeholder))
    end
  end
  def textFieldDidEnd(textField)
    if textField == get(:input)
      updatePlaceholder(get(:input), get(:placeholder))
    end
    if textField == get(:modal_inp)
      updatePlaceholder(get(:modal_inp), get(:modal_placeholder))
    end
    
  end
  def open_modal
    main = get(:modal_overlay)
    container = get(:modal_box)
    open_a_modal(main, container)
  end
  def close_modal
    main = get(:modal_overlay)
    container = get(:modal_box)
    close_a_modal(main, container)
  end
  def open_atn_modal
    main = get(:atn_modal_overlay)
    container = get(:atn_modal_box)
    open_a_modal(main, container)
  end
  def close_atn_modal
    main = get(:atn_modal_overlay)
    container = get(:atn_modal_box)
    close_a_modal(main, container)
  end
  def open_a_modal(main, container)
    main.setHidden false
    main.fade_out(0)
    container.fade_out(0)
    main.setHidden false
    main.fade_in(duration: 0.1,
      delay: 0,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 1.0
    )
    container.fade_in(duration: 0.1,
      delay: 0.1,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 1.0
    )
  end
  def close_a_modal(main, container)
    main.fade_out(duration: 0.1,
      delay: 0.1,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 0.0
    )
    container.fade_out(duration: 0.1,
      delay: 0.0,
      options: UIViewAnimationOptionCurveLinear,
      opacity: 0.0
    )
    0.3.seconds.later do
      main.setHidden true
    end
  end
end