class PermissionLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def layout
    @hideTimos = []
    @host = false
    @hide_no = false
    @closeOnYes = false
    root :main do
      add UIView, :container_shell do
        add UIView, :container do
          add UIView, :title_container do
            add UILabel, :title
          end
          add UITextView, :content
          add UIImageView, :image
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
      UITextAttributeTextColor => Color.dark_gray
    }
    content = content.gsub('<p>', '<p style="color: #877F75; font-family: Karla; text-align:center; font-size:16px; margin-bottom:16px; margin-left:8px; margin-right:8px;">')
    content = content.gsub('<em>', '<em style="font-family: Karla; font-weight: bold;">')
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
    @yes_action = false
    @yes_action = opts[:yes_action] unless opts[:yes_action].nil?
    @no_action = false
    @no_action = opts[:no_action] unless opts[:no_action].nil?
    @hide_no = false
    @hide_no = opts[:hide_no] unless opts[:hide_no].nil?
    @actionHandler = opts[:controller] unless opts[:controller].nil?
    @closeOnYes = false
    @closeOnYes = opts[:close_on_yes] unless opts[:close_on_yes].nil?
    if !opts[:image].nil? and opts[:image]
      get(:image).setHidden false
      get(:image).setImage opts[:image]
    else
      get(:image).setHidden true
    end
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
    @content_height.equals(newSize.height - 15)
  end
  def main_style
    background_color Color.white(0.8)
  end
  def container_shell_style
    background_color Color.blue
    constraints do
      top 40
      center_x.equals(:superview)
      height.equals(:superview).minus(105)
      width.equals(:superview).minus(30)
    end
    layer do
      shadow_color '#000000'.cgcolor
      shadow_opacity 0.1
      shadow_radius 8.0
      shadow_offset [1, 1]
    end
  end
  def container_style
    background_color Color.light_tan
    constraints do
      center_x.equals(:superview)
      top 0
      height.equals(:superview)
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
    backgroundColor Color.blue
  end
  def title_style
    text ''
    textColor Color.light_tan
    textAlignment NSTextAlignmentCenter
    backgroundColor Color.blue
    font Font.Vitesse_Bold(21.0)
    constraints do
      left 0
      center_y.equals(:superview)
      height 60
      width.equals(:superview)
    end
  end
  def content_style
    backgroundColor Color.clear
    scrollEnabled false
    editable false
    constraints do
      top.equals(:title_container, :bottom).plus(35)
      left 25
      right -30
      @content_height = height 10
    end
  end
  def image_style
    contentMode UIViewContentModeScaleAspectFit
    constraints do
      top.equals(:content, :bottom).plus(0)
      bottom.equals(:yes_button, :top).minus(38)
      center_x.equals(:superview)
      width.equals(:content)
    end
  end
  def yes_button_style
    font Font.Vitesse_Bold(18)
    titleColor Color.white
    backgroundColor Color.green
    target.addTarget self, action: 'yes_action', forControlEvents:UIControlEventTouchDown
    constraints do
      height 50
      center_x.equals(:superview)
      bottom.equals(:container_shell, :bottom).minus(80)
      width.equals(super_width - 60)
    end
  end
  def no_button_style
    title "No, thanks."
    font Font.Karla_Bold(15)
    titleColor Color.dark_gray
    backgroundColor Color.white
    target.addTarget self, action: 'no_action', forControlEvents:UIControlEventTouchDown
    constraints do
      height 40
      center_x.equals(:superview)
      top.equals(:yes_button, :bottom).plus(20)
    end
  end
end