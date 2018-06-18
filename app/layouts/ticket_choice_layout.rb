class TicketChoiceLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def status=(status)
    @status = status
    reapply!
  end
  def layout
    @status = 'waiting'
    root :main do
      # add UIView, :header do
      #   add UIButton, :header_back
      #   add UILabel, :header_name
      # end
      add UIScrollView, :scrollview do
        add UILabel, :title
        add TicketChoiceBlock, :double_block
        add TicketChoiceBlock, :single_block
        add UIView, :anchor
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
    background_color Color.bright_blue
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
    text "Share Your Story"
  end
  def title_style
    constraints do
      top 28
      left 0
      width.equals(:superview)
      height 50
    end
    font Font.Vitesse_Medium(26)
    textAlignment UITextAlignmentCenter
    textColor Color.bright_blue
    text "Which is right for you?"
  end
  def scrollview_style
    scrollEnabled true
    delegate self
    contentSize [super_width, 200]
    constraints do
      top.equals(:superview)
      left 0
      width super_width
      @scrollH = height(super_height)
    end
  end
  def double_block_style
    get(:double_block).setProduct('double', @controller)
    constraints do
      top.equals(:title, :bottom).plus(8)
      left 12
      width (super_width-24)
      @doubleHeight = height 520
      # newSize =  tv.sizeThatFits(CGSizeMake((super_width-24), Float::MAX))
    end
    reapply do
      get(:double_block).setProduct('double', @controller)
      1.0.seconds.later do
        updateScrollSize
      end
    end
    1.0.seconds.later do
      updateScrollSize
    end
  end
  def single_block_style
    get(:single_block).setProduct('single', @controller)
    constraints do
      top.equals(:double_block, :bottom).plus(28)
      left 12
      width (super_width-24)
      @singleHeight = height 410
      # newSize =  tv.sizeThatFits(CGSizeMake((super_width-24), Float::MAX))
    end
    reapply do
      get(:single_block).setProduct('single', @controller)
      1.0.seconds.later do
        updateScrollSize
      end
    end
    1.0.seconds.later do
      updateScrollSize
    end
  end
  def anchor_style
    constraints do
      top.equals(:single_block, :bottom).plus(4)
      height 1
      width.equals(:superview)
      left 0
    end
  end
  def updateScrollSize
    frame = get(:anchor).frame
    bot_padding = 50
    height = frame.origin.y + frame.size.height + bot_padding
    get(:scrollview).contentSize = [super_width, height]
  end
end