class CartLayout < MK::Layout
  attr_accessor :isExisting, :card, :useExisting
  def setController(controller)
    @controller = controller
  end
  def layout
    @card = false
    @isExisting = false
    @useExisting = false
    unless Me.atn.card.nil?
      @isExisting = true
      @useExisting = true
      @card = Me.atn.card
    end
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
        add UITextField, :card_num
        add ExpirationPicker, :card_exp
        add UITextField, :card_cvv
        add UITextField, :card_zip
      end
      add UIView, :card_existing_botline
      add UIButton, :card_new_btn
      add UIButton, :submit
      add UIButton, :cancel
    end
  end
  def updateVals(vals)
    @vals = vals
    reapply!
  end
  def toggleExisting
    @useExisting = !@useExisting
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
      top 32
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
    font Font.Karla_Bold(18)
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
      top.equals(:item_name, :bottom).plus(5)
      left.equals(:item_name)
      right.equals(:item_price_shell, :left).minus(16)
    end
    view = target
    reapply do
      text @vals[:descr]
      view.sizeToFit
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
      view.sizeToFit
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
    numberOfLines 2
    view = target
    reapply do
      paragraphStyle = NSMutableParagraphStyle.alloc.init
      paragraphStyle.lineSpacing = 3
      str = (@card['brand']+' ending in '+@card['last4'])+
      ' (Exp: '+@card['exp_month']+'/'+@card['exp_year']+')'
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
      view.sizeToFit
    end
  end
  def submit_style
    backgroundColor Color.orange
    titleColor Color.light_tan
    font Font.Vitesse_Bold(17)
    title "Complete Payment"
    addTarget @controller, action: 'purchase_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 16
      width.equals(:superview).minus(32)
      bottom -16
      height 40
    end
  end
  def card_form_style
    backgroundColor Color.tan
    constraints do
      left 0
      right 0
      top.equals(:item_shell, :bottom)
      height 80
    end
    always do
      if @useExisting
        hidden true
      else
        hidden false
      end
    end
  end
  def card_num_style
    keyboardType UIKeyboardTypeNumberPad
  end
  def card_cvv_style
    keyboardType UIKeyboardTypeNumberPad
  end
  def card_zip_style
    keyboardType UIKeyboardTypeNumberPad
  end
  def card_exp_style
    keyboardType UIKeyboardTypeNumberPad
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
  def textViewDidEndEditing(textView)
    updatePlaceholder
  end
  def textViewDidChange(textView)
    updatePlaceholder
  end
end