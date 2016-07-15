class ModalLayout < MK::Layout
  view :values
  def setController(controller)
    @controller = controller
  end
  def layout
    @host = false
    @list = PopupList.new
    @list.controller = self
    @list.layout = self
    values = @list.view
    root :main do
      add UIView, :container_shell do
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
    # Set data
    get(:title).setText(opts[:title])
    error_ptr = Pointer.new(:object)
    error_ptrM = Pointer.new(:object)
    content = MMMarkdown.HTMLStringWithMarkdown(opts[:content], error:error_ptrM)
    options =  {
      NSDocumentTypeDocumentAttribute => NSHTMLTextDocumentType,
      NSFontAttributeName => Font.Karla(16),
      UITextAttributeTextColor => Color.dark_gray
    }
    content += '<p></p>'
    content = content.gsub('<p>', '<p style="font-family: Karla; font-size:16px; margin-bottom:10px; margin-left:8px; margin-right:8px;">')
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
    @yes_action = opts[:yes_action] unless opts[:yes_action].nil?
    @no_action = opts[:no_action] unless opts[:no_action].nil?
    @actionHandler = opts[:controller] unless opts[:controller].nil?
    updHeight

    # Appear
    main = get(:main)
    container = get(:container_shell)
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
  def yes_action
    if !@actionHandler.nil? and !@yes_action.nil?
      @actionHandler.send(@yes_action, @item)
    end
  end
  def no_action
    if !@actionHandler.nil? and !@no.nil?
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
    0.3.seconds.later do
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
    background_color Color.light_gray(0.8)
  end
  def container_shell_style
    background_color "#ABA394".uicolor(0.25)
    constraints do
      center_x.equals(:superview)
      top super_height*0.2
      height.equals(:container).plus(0)
      width.equals(:superview).minus(60)
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
      width.equals(:superview).minus(10)
    end
    backgroundColor "#716B60".uicolor
  end
  def title_style
    text ''
    textColor Color.light_tan
    textAlignment NSTextAlignmentCenter
    backgroundColor "#716B60".uicolor
    font Font.Vitesse_Bold(21.0)
    constraints do
      left 10
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
  def yes_button_style
    font Font.Karla_Bold(15)
    titleColor Color.light_tan
    backgroundColor Color.orange
    target.addTarget self, action: 'yes_action', forControlEvents:UIControlEventTouchDown
    constraints do
      height 40
      left 0
      bottom.equals(:container, :bottom)
      width.equals(:superview).divided_by(2)
    end
  end
  def no_button_style
    title "Cancel"
    font Font.Karla_Bold(15)
    titleColor Color.dark_gray
    backgroundColor Color.dark_yellow_tan
    target.addTarget self, action: 'no_action', forControlEvents:UIControlEventTouchDown
    constraints do
      width.equals(:superview).divided_by(2)
      height 40
      right 0
      left.equals(:yes_button, :right)
      bottom.equals(:container, :bottom)
    end
  end
end