class LoginScreen < PM::Screen
  status_bar :light
  def on_load
    @layout = LoginLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    @slid_up = false
    true
  end
  def textFieldDidBeginEditing(textfield)
    @layout.slide_up
  end
  def textFieldDidEndEditing(textfield)
    @layout.slide_down
  end
  def touchesBegan(touches, withEvent: event)
    touch = event.allTouches.anyObject
    email = @layout.get(:email_input)
    pw = @layout.get(:password_input)
    if email.isFirstResponder && touch.view != email
      email.resignFirstResponder
    elsif pw.isFirstResponder && touch.view != pw
      pw.resignFirstResponder
    end
    super
  end
  def login_action
    @layout.setButtonTitle('Logging in...')
    email = @layout.get(:email_input).text
    password = @layout.get(:password_input).text
    params = {username: email, password: password, request_user_token: 1}
    Api.post 'user/login', params do |rsp|
      if rsp['json']['user_token']
        Me.saveUserToken rsp['json']['user_token'] 
        @layout.setButtonTitle('Success!')
      else
        if not rsp['json']['loggedin']
          @layout.setButtonTitle 'Wrong Email/Password'
        else
          @layout.setButtonTitle 'Try Again'
        end
      end
      3.seconds.later do
        @layout.setButtonTitle 'Login to WDS'
      end
    end
  end
  def forgot_action
    puts 'forgot'
  end
end