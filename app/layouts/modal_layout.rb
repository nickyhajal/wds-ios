class ModalLayout < MK::Layout
  view :values
  def setController(controller)
    @controller = controller
  end
  def layout
    @hideTimos = []
    @host = false
    @list = PopupList.new
    @list.controller = self
    @list.layout = self
    @hide_no = false
    @closeOnYes = false
    values = @list.view
    root :main do
      add UIView, :container_shell do
        add UITextView, :disclaimer
        add UIView, :container do
          add UIView, :title_container do
            add UILabel, :title
          end
          add UITextView, :content
          add UIButton, :yes_button
          add UIButton, :no_button
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
  def content(title, content, action)
  end
  def open(opts)
    if @hideTimos.length
      @hideTimos.each do |timo|
        timo.invalidate
      end
      @hideTimos = []
    end
    # Set data
    get(:title).setText(opts[:title])
    error_ptr = Pointer.new(:object)
    error_ptrM = Pointer.new(:object)
    content = MMMarkdown.HTMLStringWithMarkdown(opts[:content], error:error_ptrM)
    options =  {
      NSDocumentTypeDocumentAttribute => NSHTMLTextDocumentType,
      NSFontAttributeName => Font.Karla(16),
      UITextAttributeTextColor => Color.dark_gray_blue
    }
    content += '<p></p>'
    content = content.gsub('<p>', '<p style="font-family: Graphik App; font-size:16px; margin-bottom:10px; margin-left:8px; margin-right:8px;">')
    content = NSAttributedString.alloc.initWithData(
      content.dataUsingEncoding(NSUTF8StringEncoding),
      options:options,
      documentAttributes:nil,
      error:error_ptr
    )
    @item = opts[:item]
    get(:content).attributedText = content
    get(:yes_button).title = opts[:yes_text] unless opts[:yes_text].nil?
    get(:no_button).title = opts[:no_text] unless opts[:no_text].nil?
    if !opts[:disclaimer].nil? and opts[:disclaimer].length > 0
      get(:disclaimer).attributedText = opts[:disclaimer].attrd({
        NSFontAttributeName => Font.Karla_Italic(15),
        UITextAttributeTextColor => "#716B60".uicolor
      })
      get(:disclaimer).setHidden false
    else
      get(:disclaimer).setHidden true
    end
    @yes_action = false
    @yes_action = opts[:yes_action] unless opts[:yes_action].nil?
    @no_action = false
    @no_action = opts[:no_action] unless opts[:no_action].nil?
    @hide_no = false
    @hide_no = opts[:hide_no] unless opts[:hide_no].nil?
    @actionHandler = opts[:controller] unless opts[:controller].nil?
    @closeOnYes = false
    @closeOnYes = opts[:close_on_yes] unless opts[:close_on_yes].nil?
    updHeight
    reapply!

    # Appear
    main = get(:main)
    container = get(:container_shell)
    main.setHidden false
    if opts[:instant_appear].nil? || !opts[:instant_appear]
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
    else
      main.fade_in(0)
      container.fade_in(0)
    end
  end
  def yes_action
    if !@actionHandler.nil? and !@yes_action.nil? and @yes_action
      @actionHandler.send(@yes_action, @item)
    end
    if @closeOnYes
      close
    end
  end
  def no_action
    if !@actionHandler.nil? and !@no_action.nil? and @no_action
      @actionHandler.send(@no_action, @item)
    end
    close
  end
  def close
    main = get(:main)
    container = get(:container_shell)
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
    @hideTimos << 0.3.seconds.later do
      main.setHidden true
    end
  end
  def updHeight
    content = get(:content)
    container = get(:container)
    fixedWidth = content.frame.size.width
    newSize =  content.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
    @content_height.equals(newSize.height+25)
  end
  def main_style
    view.on_tap do
      close
    end
    background_color Color.light_gray(0.93)
  end
  def container_shell_style
    background_color "#ABA394".uicolor(0.25)
    constraints do
      center_x.equals(:superview)
      top super_height*0.2
      height.equals(:container).plus(0)
      width.equals(:superview).minus(60)
    end
    layer do
      shadow_color '#000000'.cgcolor
      shadow_opacity 0.12
      shadow_radius 10.0
      shadow_offset [1, 1]
    end
  end
  def container_style
    background_color Color.light_tan
    constraints do
      center_x.equals(:superview)
      top 0
      height.equals(:content).plus(40)
      width.equals(:superview).minus(0)
    end
  end
  def title_container_style
    constraints do
      left 0
      top 0
      height 50
      width.equals(:superview)
    end
    backgroundColor Color.bright_blue
  end
  def title_style
    text ''
    textColor Color.white
    textAlignment NSTextAlignmentCenter
    backgroundColor Color.bright_blue
    font Font.Vitesse_Bold(21.0)
    constraints do
      left 0
      center_y.equals(:superview)
      height 50
      width.equals(:superview)
    end
  end
  def content_style
    backgroundColor Color.clear
    scrollEnabled false
    editable false
    constraints do
      top.equals(:title_container, :bottom).plus(15)
      left 10
      right -20
      @content_height = height 0
    end
  end
  def disclaimer_style
    backgroundColor Color.clear
    scrollEnabled false
    editable false
    font Font.Karla_Italic(15)
    constraints do
      top.equals(:container, :bottom).plus(5)
      left 18
      right -20
      height 100
    end
  end
  def yes_button_style
    font Font.Karla_Bold(15)
    titleColor Color.light_tan
    backgroundColor Color.orange
    title "Cancel"
    target.addTarget self, action: 'yes_action', forControlEvents:UIControlEventTouchDown
    constraints do
      height 40
      left 0
      bottom.equals(:container, :bottom)
      @yesWidth = width.equals(get(:container).frame.size.width)
    end
    reapply do
      w = get(:container).frame.size.width
      if @hide_no
        @yesWidth.equals(w)
      else
        @yesWidth.equals(w/2)
      end
    end
  end
  def no_button_style
    title "Cancel"
    font Font.Karla_Bold(15)
    titleColor Color.dark_gray
    backgroundColor Color.dark_yellow_tan
    target.addTarget self, action: 'no_action', forControlEvents:UIControlEventTouchDown
    constraints do
      @noWidth = width.equals(get(:container).frame.size.width)
      height 40
      right 0
      @noLeft = left.equals(:yes_button, :right)
      bottom.equals(:container, :bottom)
    end
    reapply do
      if @hide_no
        @noWidth.equals(0)
        hidden true
      else
        @noWidth.equals(get(:container).frame.size.width/2)
        hidden false
      end
    end
  end
end