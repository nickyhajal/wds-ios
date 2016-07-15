class PostScreen < PM::Screen
  status_bar :dark
  attr_accessor :controller, :layout, :dispatch
  def init_layout
    @layout = PostLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    @layout.get(:input).layoutIfNeeded
  end
  def will_appear
    @layout.get(:input).becomeFirstResponder
    @layout.get(:input).layoutIfNeeded
  end
  def send_post_action
    text = @layout.get(:input).text
    @layout.get(:post).title = 'Posting'
    @layout.get(:input).text
    @layout.get(:input).resignFirstResponder
    @dispatch.post text do |err|
      if err
        @layout.get(:post).title = 'Post'
        $APP.offline_alert
      else
        @layout.get(:post).title = 'Posted!'
        @layout.get(:input).text = ''
        @layout.updatePlaceholder
        0.03.seconds.later do
          close_screen
          0.5.seconds.later do
            @layout.get(:post).title = 'Post'
          end
        end
      end
    end
  end
  def cancel_post_action
    @layout.get(:input).resignFirstResponder
    0.2.seconds.later do
      close_screen
      UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
    end
  end
  def shouldAutorotate
    false
  end
end