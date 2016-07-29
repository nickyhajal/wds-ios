class CartLayout < MK::Layout
  attr_accessor :isExisting, :card, :useExisting, :month, :year, :charging
  def setController(controller)
    @controller = controller
  end
  def layout
    @charging = false
    @expShouldBeOpen = false
    @expIsOpen = false
    @month = false
    @year = false
    @card = false
    @isExisting = false
    @useExisting = false
    @status = 'waiting'
    updCard
    root :main do
      add UIView, :header do
        add UILabel, :header_title
      end
      add UIView, :item_shell do
        add UILabel, :item_name
        add UILabel, :item_descr
        add UIView, :item_price_shell do
          add UIView, :item_priceline
          add UILabel, :item_price
        end
        add UIView, :item_botline
      end
      add UIView, :card_existing do
        add UILabel, :card_ident
        add UILabel, :card_exp
      end
      add UIView, :card_form do
        add UIButton, :card_scan_btn
        add SZTextView, :card_num
        add UIButton, :card_exp_btn
        add SZTextView, :card_cvv
      end
      add UIView, :card_existing_botline
      add UIView, :card_new_botline
      add UIButton, :card_new_btn
      add UIButton, :card_existing_btn
      add UIButton, :submit
      add UIButton, :cancel
      add UIView, :card_exp_shell do
        add ExpirationPicker, :card_exp_picker
        add UIButton, :card_exp_close
      end
      add ModalLayout, :modal
    end
  end
  def syncCard
    Me.sync do
      updCard
    end
  end
  def updCard
    if !Me.atn.card.nil? and Me.atn.card
      @isExisting = true
      @useExisting = true
      @card = Me.atn.card
    end
  end
  def updateVals(vals)
    @vals = vals
    reapply!
  end
  def toggleExisting
    @useExisting = !@useExisting
    closeKeyboard
    reapply!
  end
  def openExp
    @expShouldBeOpen = true
    closeKeyboard
    reapply!
  end
  def closeExp
    @expShouldBeOpen = false
    reapply!
  end
  def setMonth(month)
    @month = month
    reapply!
  end
  def setYear(year)
    @year = year
    reapply!
  end
  def status=(status)
    @status = status
    reapply!
  end
  def closeKeyboard
    get(:main).endEditing(true)
  end
  def updateExp(month, year)
    @month = month
    @year = year
    reapply!
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
  def cancel_style
    title "x"
    titleColor Color.light_tan
    font Font.Vitesse_Medium(19)
    target.addTarget @controller, action: 'close_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 6
      top 24
    end
    target.sizeToFit
  end
  def header_style
    backgroundColor Color.green
    constraints do
      left 0
      right 0
      top 0
      height 60
    end
  end
  def header_title_style
    text "Let's Do This!"
    font Font.Vitesse_Medium(18)
    textColor Color.light_tan
    constraints do
      center_x.equals(:superview)
      top 30
    end
    target.sizeToFit
  end
  def item_shell_style
    backgroundColor Color.tan
    constraints do
      left 0
      right 0
      top.equals(:header, :bottom)
      height 80
    end
  end
  def item_name_style
    font Font.Karla_Bold(20)
    textColor Color.dark_gray
    constraints do
      top 16
      left 16
    end
    view = target
    reapply do
      text @vals[:name]
      view.sizeToFit
    end
  end
  def item_descr_style
    font Font.Vitesse(15)
    textColor Color.dark_gray
    numberOfLines 1
    lineBreakMode NSLineBreakByTruncatingTail
    constraints do
      top.equals(:item_name, :bottom).plus(3)
      left.equals(:item_name)
      right.equals(:item_price_shell, :left).minus(16)
      height 25
    end
    view = target
    reapply do
      text @vals[:descr]
    end
  end
  def item_botline_style
    backgroundColor Color.dark_gray(0.15)
    constraints do
      bottom 0
      width.equals(:superview)
      height 2
      left 0
    end
  end
  def item_priceline_style
    backgroundColor Color.dark_gray(0.15)
    constraints do
      top 0
      left 0
      width 2
      height.equals(:superview)
    end
  end
  def item_price_shell_style
    backgroundColor Color.light_tan(0.3)
    constraints do
      top 0
      right 0
      height.equals(:superview)
      width 80
    end
  end
  def item_price_style
    font Font.Vitesse_Medium(24)
    textColor Color.dark_gray
    numberOfLines 1
    textAlignment UITextAlignmentCenter
    constraints do
      left 2
      right 0
      center_y.equals(:superview).plus(1)
      width 80
    end
    view = target
    reapply do
      text '$'+@vals[:price]
    end
  end
  def card_existing_botline_style
    backgroundColor Color.dark_gray(0.15)
    constraints do
      top.equals(:card_existing, :bottom)
      width.equals(:superview)
      height 2
      left 0
    end
    always do
      if @useExisting
        hidden false
      else
        hidden true
      end
    end
  end
  def card_new_botline_style
    backgroundColor Color.dark_gray(0.15)
    constraints do
      top.equals(:card_form, :bottom)
      width.equals(:superview)
      height 2
      left 0
    end
    always do
      if @useExisting
        hidden true
      else
        hidden false
      end
    end
  end
  def card_new_btn_style
    backgroundColor Color.tan(0.8)
    titleColor Color.orange
    font Font.Vitesse_Medium(14)
    title "Add New Card"
    constraints do
      left 0
      right 0
      top.equals(:card_existing_botline, :bottom)
      height 36
    end
    always do
      if @useExisting
        hidden false
      else
        hidden true
      end
    end
    target.addTarget self, action: 'toggleExisting', forControlEvents:UIControlEventTouchDown
  end
  def card_existing_btn_style
    backgroundColor Color.tan(0.8)
    titleColor Color.orange
    font Font.Vitesse_Medium(14)
    title "Use Existing Card"
    constraints do
      left 0
      right 0
      top.equals(:card_new_botline, :bottom)
      height 36
    end
    always do
      if @isExisting
        if @useExisting
          hidden true
        else
          hidden false
        end
      else
        hidden true
      end
    end
    target.addTarget self, action: 'toggleExisting', forControlEvents:UIControlEventTouchDown
  end
  def card_existing_style
    backgroundColor Color.bright_yellowish_tan
    constraints do
      left 0
      right 0
      top.equals(:item_shell, :bottom)
      height 80
    end
    always do
      if @useExisting
        hidden false
      else
        hidden true
      end
    end
  end
  def card_ident_style
    font Font.Karla_Bold(16)
    textColor Color.dark_gray
    constraints do
      center_y.equals(:superview)
      left 16
    end
    numberOfLines 3
    view = target
    reapply do
      paragraphStyle = NSMutableParagraphStyle.alloc.init
      paragraphStyle.lineSpacing = 3
      if @useExisting
        str = (@card['brand']+' ending in '+@card['last4'])+
        "\n"+'(Exp: '+@card['exp_month']+'/'+@card['exp_year']+')'
        str = str.attrd({
          NSFontAttributeName => Font.Karla_Bold(15),
          UITextAttributeTextColor => Color.dark_gray,
          NSParagraphStyleAttributeName => paragraphStyle
        })
        str = "CHARGE TO\n".attrd({
          NSFontAttributeName => Font.Vitesse_Bold(12),
          UITextAttributeTextColor => Color.dark_gray(0.6),
          NSParagraphStyleAttributeName => paragraphStyle
        })+str
        view.setAttributedText str
      end
      view.sizeToFit
    end
  end
  def submit_style
    backgroundColor Color.orange
    titleColor Color.light_tan
    font Font.Vitesse_Bold(17)
    always do
      case @status
      when 'waiting'
        title "Complete Payment"
      when 'processing'
        title "Processing Payment..."
      when 'success'
        title "Success!"
      when 'error'
        title "There was a problem."
      end
    end
    addTarget @controller, action: 'purchase_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 16
      width.equals(:superview).minus(32)
      bottom -16
      height 40
    end
  end
  def card_form_style
    backgroundColor Color.bright_yellowish_tan
    constraints do
      left 0
      right 0
      top.equals(:item_shell, :bottom)
      bottom.equals(:card_cvv, :bottom).plus(16)
    end
    always do
      if @useExisting
        hidden true
      else
        hidden false
      end
    end
  end
  def card_scan_btn_style
    title "Scan Card"
    titleColor Color.light_tan
    backgroundColor Color.blue
    font Font.Karla_Bold(15)
    target.addTarget @controller, action: 'onCapture', forControlEvents:UIControlEventTouchDown
    constraints do
      left 16
      right -16
      @scanTop = top 0
      @scanBtnH = height 0
    end
    reapply do
      if CardIOUtilities.canReadCardWithCamera
        @scanBtnH.equals(38)
        @scanTop.equals(16)
        hidden false
      else
        @scanBtnH.equals(0)
        @scanTop.equals(0)
        hidden true
      end
    end
  end
  def card_num_style
    font Font.Karla_Bold(16)
    textColor Color.blue
    placeholderTextColor Color.dark_gray
    keyboardType UIKeyboardTypeNumberPad
    placeholder "Card Number"
    backgroundColor Color.orangish_gray(0.2)
    textContainerInset UIEdgeInsetsMake(10,7,0,0)
    delegate self
    constraints do
      top.equals(:card_scan_btn, :bottom).plus(16)
      left 16
      width.equals(:superview).minus(32)
      height 40
    end
  end
  def card_exp_btn_style
    font Font.Karla_Bold(16)
    backgroundColor Color.orangish_gray(0.2)
    titleColor Color.dark_gray
    title "Exp. Date"
    contentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
    contentEdgeInsets UIEdgeInsetsMake(3,7,0,0)
    target.addTarget self, action: 'openExp', forControlEvents:UIControlEventTouchDown
    constraints do
      top.equals(:card_num, :bottom).plus(16)
      left.equals(:card_num, :left)
      right.equals(:card_cvv, :left).minus(16)
      height.equals(:card_num)
    end
    reapply do
      if @month and @year
        title "Exp: "+@month + "/"+ @year
        titleColor Color.blue
      else
        titleColor Color.dark_gray
        title "Exp. Date"
      end
    end
  end
  def card_cvv_style
    placeholder "Card CVV"
    font Font.Karla_Bold(16)
    textColor Color.blue
    placeholderTextColor Color.dark_gray
    keyboardType UIKeyboardTypeNumberPad
    backgroundColor Color.orangish_gray(0.2)
    delegate self
    textContainerInset UIEdgeInsetsMake(10,7,0,0)
    constraints do
      top.equals(:card_exp_btn)
      right -16
      height.equals(:card_num)
      width.equals(120)
    end
  end
  def card_exp_shell_style
    backgroundColor Color.dark_yellow_tan
    constraints do
      @exp_b = bottom 220
      left 0
      right 0
      height 220
    end
    view = target
    reapply do
      if @expShouldBeOpen != @expIsOpen
        dir = :down
        finishPoint = 220
        if @expShouldBeOpen
          finishPoint = 0
          dir = :up
        end
        view.slide dir, 220
        @expIsOpen = @expShouldBeOpen
        0.5.seconds.later do
          @exp_b.equals(finishPoint)
        end
      end
    end
  end
  def card_exp_close_style
    title "Done"
    target.addTarget self, action: 'closeExp', forControlEvents:UIControlEventTouchDown
    font Font.Karla_Bold(16)
    titleColor Color.coffee(0.8)
    constraints do
      top 12
      right (-8)
      width 60
      height 20
    end
  end
  def card_exp_picker_style
    target.controller = self
    constraints do
      top 20
      left 0
      right 0
      bottom 0
    end
  end
  def modal_style
    hidden true
    constraints do
      top.equals(0)
      left.equals(0)
      width.equals(super_width)
      height.equals(super_height)
    end
  end
  def updatePlaceholder
    textView = get(:input)
    if textView.hasText
      get(:placeholder).hidden = true
    else
      get(:placeholder).hidden = false
    end
    get(:input).layoutIfNeeded
  end
  def textViewShouldBeginEditing(textView)
    flexibleSpace = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:self, action:nil)
    barButton = UIBarButtonItem.alloc.initWithTitle("Done",
      style:UIBarButtonItemStylePlain, target:self, action:'closeKeyboard')
    barButton.setTitleTextAttributes({
     NSFontAttributeName => Font.Karla_Bold(16),
     NSForegroundColorAttributeName => Color.blue
    }, forState:UIControlStateNormal)
    toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, super_width, 44))
    toolbar.items = NSArray.arrayWithObjects(flexibleSpace, barButton, nil);
    textView.inputAccessoryView = toolbar;
  end
  def textViewDidBeginEditing(textView)
    closeExp
  end
  def textViewDidEndEditing(textView)
  end
  def textViewDidChange(textView)
  end
end