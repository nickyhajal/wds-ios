class LoginLayout < MK::Layout
  include SugarCube::Timer
  attr_accessor :login_top
  def setController(controller)
    @controller = controller
  end
  def layout
    @slid_up = false
    root :main do
      add UIImageView, :big_logo do
        @logo_image = image UIImage.imageNamed("big_logo")
      end
      add UIView, :login_container do
        add UIView, :email do
          add UITextField, :email_input
        end
        add UIView, :password do
          add UITextField, :password_input
        end
        add UIButton, :submit
        add UIButton, :forgot
      end
    end
  end
  def logo_top
    if iphone4
      85
    else
      105
    end
  end
  def container_top
    if iphone4
      260
    else
      300
    end
  end
  def iphone4
    super_height < 500
  end
  def slide_up
    @slid_up = true
    # get(:big_logo).setAlpha 0.0
    get(:big_logo).fade_out(0.3)
    @login_top.equals(60)
    @login_height.equals super_height - 60
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
  end
  def slide_down
    @slid_up = false
    0.2.seconds.later do
      unless @slid_up
        @login_top.equals(container_top)
        @login_height.equals super_height - container_top
        get(:big_logo).fade_in(0.3)
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
          self.view.layoutIfNeeded  # applies the constraint change
        end, completion: nil)
      end
    end
  end
  def super_width
    get(:main).frame.size.width
  end
  def super_height
    get(:main).frame.size.height
  end
  def setButtonTitle(title)
    get(:submit).setTitle title, forState:UIControlStateNormal
  end
  def main_style
    background_color Color.bright_blue
  end
  def big_logo_style
    w = super_width - 60
    h = w * 0.45
    constraints do
      width w
      height h
      top ((container_top+75) / 2) - (h / 2)
      left (super_width/2) - (w/2)
    end
  end
  def login_container_style
    background_color Color.bright_blue
    constraints do
      width.equals(:superview)
      @login_height = height super_height - container_top
      @login_top = top container_top
      left 0
    end
  end
  def email_style
    backgroundColor "#F2F2EA".uicolor
    w = super_width - 60
    constraints do
      width w
      height 52
      left (super_width / 2) - (w / 2)
      top iphone4 ? 25 : 40
    end
  end
  def email_input_style
    backgroundColor UIColor.clearColor
    target.delegate = @controller
    target.autocorrectionType = UITextAutocorrectionTypeNo
    target.autocapitalizationType = UITextAutocapitalizationTypeNone
    target.keyboardType = UIKeyboardTypeEmailAddress
    textColor Color.orange
    attributedPlaceholder NSAttributedString.alloc.initWithString("E-Mail Address", attributes:{
      NSForegroundColorAttributeName => Color.orange
    })
    font Font.Karla_Bold(16)
    target.addTarget @controller, action:'login_action', forControlEvents:UIControlEventEditingDidEndOnExit
    constraints do
      top 0
      left 10
      width.equals(:superview).minus(10)
      height  52
    end
  end
  def password_style
    backgroundColor "#F2F2EA".uicolor
    w = super_width - 60
    constraints do
      width w
      height 52
      left (super_width / 2) - (w / 2)
      top iphone4 ? 69 : 84
    end
  end
  def password_input_style
    backgroundColor UIColor.clearColor
    textColor Color.orange
    target.delegate = @controller
    attributedPlaceholder NSAttributedString.alloc.initWithString("Password", attributes:{
      NSForegroundColorAttributeName => Color.orange
    })
    target.secureTextEntry = true
    font Font.Karla_Bold(16)
    target.addTarget @controller, action:'login_action', forControlEvents:UIControlEventEditingDidEndOnExit
    constraints do
      top 0
      left 10
      width.equals(:superview).minus(10)
      height  52
    end
  end
  def submit_style
    title "Login to WDS"
    backgroundColor Color.orange
    font Font.Karla_Bold(18)
    w = super_width - 60
    target.addTarget @controller, action:'login_action', forControlEvents:UIControlEventTouchUpInside
    constraints do
      width w
      height 44
      left (super_width / 2) - (w / 2)
      top iphone4 ? 121 : 136
    end
  end
  def forgot_style
    title "Forgot your password?"
    backgroundColor UIColor.clearColor
    titleColor "#F2F2EA".uicolor, forState:UIControlStateNormal
    font Font.Karla_Bold(16)
    w = super_width - 60
    target.addTarget @controller, action:'forgot_action', forControlEvents:UIControlEventTouchUpInside
    constraints do
      width w
      height 44
      left (super_width / 2) - (w / 2)
      top iphone4 ? 170 : 190
    end
  end
  def email_label_style
    text "Email Address"
  end
end