class TicketChoiceBlock < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def status=(status)
    @status = status
    reapply!
  end
  def setProduct(product, controller)
    @controller = controller
    pre = $STATE[:pre].nil? ? {single_soldout: 0, double_soldout: 0} : $STATE[:pre];
    if product == 'single'
      @soldOut = pre[:single_soldout].nil? ? false : pre[:single_soldout] > 0
      @cta = @soldOut ? 'Sold out!' : 'Join us next year!'
      @price = '597'
      @product = 'WDS 2019'
      @descr = "Join us again next year! Pre-order now for a significantly discounted cost over the standard ticket."
      @action = 'single_buy_action'
      @note = "• WDS 2019 will be from June 25th to July 1st, 2019.

• You'll assign your 2019 ticket(s) from an email confirmation after purchase.

• Your pre-order includes 1 free Insider Access Academy

• Tickets can be transferred for $100 up to 30 days before the event.
"
    else
      @soldOut = pre[:double_soldout].nil? ? false : pre[:double_soldout] > 0
      @cta = @soldOut ? 'Sold out!' : 'Join us both years!'
      @price = '997'
      @product = 'WDS 2019 & 2020'
      @action = 'double_buy_action'
      @descr = "A special offer to join us for the last 2 years of WDS at an incredible price. Just 200 tickets available."
      @note = "• WDS 2019 will be from June 25th to July 1st, 2019.

• The dates for WDS 2020 will be between June-August 2020 and announced in mid-2019.

• You'll assign your 2019 ticket(s) from an email confirmation after purchase. Your 2020 ticket(s) will be assigned before the end of 2019.

• Your pre-order includes 1 free Insider Access Academy for 2019 & 2020

• Tickets can be transferred for $100 up to 30 days before the event (2019 & 2020).
      "
    end
    reapply!
  end
  def layout
    @price = '$999'
    @descr = ''
    @product = 'WDS 2019 & 2020'
    @note = ''
    root :main do
      add UILabel, :title
      # add UILabel, :price_shadow
      add UILabel, :price
      add UITextView, :descr
      add UIButton, :submit
      add UIView, :line
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.white
    reapply do
      get(:main).alpha = @soldOut ? 0.4 : 1
    end
  end
  def title_style
    constraints do
      top 15
      left 20
      width.equals(:superview)
      height 40
    end
    font Font.Vitesse_Medium(22)
    textColor Color.black
    always do
      text @product
    end
  end
  def price_style
    constraints do
      top 15
      right.equals(:superview, :right).minus(14)
      width 60
      height 40
    end
    font Font.Vitesse_Medium(22)
    textColor Color.bright_green
    always do
      text "$#{@price}"
    end
  end
  def descr_style
    editable false
    scrollEnabled false
    backgroundColor Color.clear
    tv = target
    constraints do
      top.equals(:title, :bottom).plus(1)
      left 12
      width (super_width-44)
      @msgHeight = height 0
    end
    reapply do
      str = @descr.attrd({
        NSFontAttributeName => Font.Karla(18),
        UITextAttributeTextColor => Color.dark_gray
      })
      note = @note.attrd({
        NSFontAttributeName => Font.Karla(16),
        UITextAttributeTextColor => Color.dark_gray
      })
      str = str + "\n\n" + note
      attributedText str
      newSize =  tv.sizeThatFits(CGSizeMake((super_width-24), Float::MAX))
      @msgHeight.equals(newSize.height)
    end
  end
  def sep_style
    backgroundColor Color.orangish_gray(0.8)
    constraints do
      top.equals(:msg, :bottom).plus(12)
      left.equals(:msg, :left)
      right.equals(:msg, :right)
      height 3
    end
  end
  def line_style
    backgroundColor "#E54B2C".uicolor
    constraints do
      height 2
      left 0
      width.equals(:superview)
      bottom.equals(:superview, :bottom)
    end
  end
  def submit_style
    backgroundColor Color.orange
    titleColor Color.light_tan
    font Font.Vitesse_Bold(19)
    reapply do
      title @cta
      if @soldOut
        removeTarget nil, action:nil, forControlEvents: UIControlEventAllEvents
      else
        addTarget @controller, action: @action, forControlEvents:UIControlEventTouchDown
      end

    end
    constraints do
      bottom.equals(:line, :bottom)
      left 0
      width.equals(:superview)
      height 50
    end
  end
end