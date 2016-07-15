class PopupLayout < MK::Layout
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
          add values, :value_list
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
  def open(vals, title, host)
    @host = host
    self.setValues(vals)
    get(:title).setText(title)
    @height.equals((vals.length*50)+56)
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
  def selectVal(val)
    @host.select(val)
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
    @host = false
  end
  def setValues(vals)
    @list.setValues(vals)
  end
  def main_style
    target.on_tap do
      close
    end
    background_color Color.light_gray(0.8)
  end
  def container_shell_style
    background_color "#716B60".uicolor
    constraints do
      center_x.equals(:superview)
      top super_height*0.2
      @height = height 120
      width.equals(:superview).minus(60)
    end
  end
  def container_style
    background_color Color.light_tan
    constraints do
      center_x.equals(:superview)
      top 0
      height.equals(:superview).minus(6)
      width.equals(:superview).minus(12)
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
    backgroundColor "#716B60".uicolor
    font Font.Karla_Italic(24.0)
    constraints do
      left 10
      center_y.equals(:superview)
      height 50
      width.equals(:superview)
    end
  end
  def value_list_style
    backgroundColor Color.light_tan
    constraints do
      top.equals(:title_container, :bottom)
      left 0
      right "100%"
      bottom.equals(:container, :bottom)
    end
  end
end