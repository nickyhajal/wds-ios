class LoginScreen < PM::Screen
  status_bar :light
  def on_load
    @layout = LoginLayout.new(root: self.view).build
    @layout.setController self
    true
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