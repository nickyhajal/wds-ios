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
  def slide_up
    @slid_up = true
    get(:big_logo).setAlpha 0.0
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
        @login_top.equals(300)
        @login_height.equals super_height - 300
        get(:big_logo).setAlpha 1.0
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
    background_color "#B0BA1E".uicolor
  end
  def big_logo_style
    constraints do
      width 191
      height 215
      top 55
      left (super_width/2) - (190/2) - 18
    end
  end
  def login_container_style
    background_color "#BDC72B".uicolor
    constraints do
      width.equals(:superview)
      @login_height = height super_height - 300
      @login_top = top 300
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
      top 40
    end
  end
  def email_input_style
    backgroundColor UIColor.clearColor
    target.delegate = @controller
    textColor "#EB9622".uicolor
    attributedPlaceholder NSAttributedString.alloc.initWithString("E-Mail Address", attributes:{
      NSForegroundColorAttributeName => "#EB9622".uicolor
    })
    font UIFont.fontWithName("Karla-Bold", size:16.0)
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
      top 84
    end
  end
  def password_input_style
    backgroundColor UIColor.clearColor
    textColor "#EB9622".uicolor
    target.delegate = @controller
    attributedPlaceholder NSAttributedString.alloc.initWithString("Password", attributes:{
      NSForegroundColorAttributeName => "#EB9622".uicolor
    })
    target.secureTextEntry = true
    font UIFont.fontWithName("Karla-Bold", size:16.0)
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
    backgroundColor "#EB9622".uicolor
    font UIFont.fontWithName("Karla-Bold", size:18.0)
    w = super_width - 60
    target.addTarget @controller, action:'login_action', forControlEvents:UIControlEventTouchUpInside
    constraints do
      width w
      height 44
      left (super_width / 2) - (w / 2)
      top 136
    end
  end
  def forgot_style
    title "Forgot your password?"
    backgroundColor UIColor.clearColor
    titleColor "#F2F2EA".uicolor, forState:UIControlStateNormal
    font UIFont.fontWithName("Karla-Bold", size:16.0)
    w = super_width - 60
    target.addTarget @controller, action:'forgot_action', forControlEvents:UIControlEventTouchUpInside
    constraints do
      width w
      height 44
      left (super_width / 2) - (w / 2)
      top 190
    end
  end
  def email_label_style
    text "Email Address"
  end
end  