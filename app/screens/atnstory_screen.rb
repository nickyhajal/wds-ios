class AtnStoryScreen < PM::Screen
  title "Notes"
  status_bar :light
  attr_accessor :layout
  def on_load
    @layout = AtnStoryLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    0.5.seconds.later do
      @layout.updateScrollSize
    end
    UIKeyboardWillShowNotification.add_observer(self, 'keyboardWillShow:')
    UIKeyboardWillHideNotification.add_observer(self, 'keyboardWillHide:')
    true
  end
  def post_story_action
    @layout.status = 'processing'
    phone = @layout.get(:phone_inp).text
    story = @layout.get(:story_inp).text
    Store.set('atnstory17', 'submitted')
    Api.post "user/story", {phone: phone, story: story} do |rsp|
      @layout.status = 'success'
      3.0.seconds.later do
        @layout.status = 'waiting'
        close_screen
      end
    end
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def close_action
    @layout.view.endEditing true
    close_screen
  end
  def shouldAutorotate
    false
  end
end