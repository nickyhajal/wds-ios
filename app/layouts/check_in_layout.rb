class CheckInLayout < MK::Layout
  view :place_view
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add place_view, :place_list
      add UIView, :auto_shell do
        add UILabel, :auto_label
        add UITextView, :auto_descr
        add UISwitch, :auto_switch
      end
      add UIView, :auto_line
    end
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
  def place_list_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      width super_width
      @listTop = top 64
      @listHeight = height (super_height-181)
    end
  end
  def auto_line_style
    constraints do
      top.equals(:auto_shell, :top).minus(2)
      height 2
      width super_width
      left 0
    end
    backgroundColor Color.dark_gray(0.25)
  end
  def auto_shell_style
    constraints do
      top.equals(:place_list, :bottom)
      height 65
      width super_width
      left 0
    end
    backgroundColor Color.tan
  end
  def auto_label_style
    constraints do
      left 10
      top 10
    end
    text 'Auto Check-In'
    textColor Color.dark_gray
    font Font.Vitesse_Medium(18.0)
  end
  def auto_descr_style
    constraints do
      top.equals(:auto_label).plus(10)
      left 5
      width 230
      height 200
    end
    backgroundColor Color.clear
    text "We'll automatically check you in when you're at a listed venue."
    textColor Color.dark_gray
    font Font.Karla(13.5)
  end
  def auto_switch_style
    constraints do
      right -10
      top 10
    end
    onTintColor Color.green
    tintColor Color.light_gray
    switch = target
    target.setOn(Me.shouldAutoCheckIn, animated: false)
    addTarget @controller, action: "auto_change", forControlEvents: UIControlEventValueChanged
  end
end