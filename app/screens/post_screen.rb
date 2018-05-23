class PostScreen < PM::Screen
  status_bar :dark
  attr_accessor :controller, :layout, :dispatch, :media
  def init_layout
    @media = false
    @layout = PostLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    @layout.get(:input).layoutIfNeeded
  end
  def will_appear
    @layout.get(:input).becomeFirstResponder
    @layout.get(:input).layoutIfNeeded
    UIKeyboardWillShowNotification.add_observer(self, 'keyboardWillShow:')
    UIKeyboardWillHideNotification.add_observer(self, 'keyboardWillHide:')
  end
  def send_post_action
    text = @layout.get(:input).text
    if text.length > 0
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
          @layout.clearMedia
          0.03.seconds.later do
            close_screen
            0.5.seconds.later do
              @layout.get(:post).title = 'Post'
            end
          end
        end
      end
    end
  end
  def setMedia(id, image)
    @media = id
    @dispatch.mediaAttached = id
    @layout.setMedia(id, image)
  end
  def clearMedia
    @media = false
    @dispatch.mediaAttached = false
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def camera_action
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
      Api.postImage result[:original_image].scale_to_fill(CGSizeMake(1900, 1900)) do |status, rsp|
        if status == 'success'
          setMedia rsp[:id], result[:original_image]
        elsif status == 'progress'
          @layout.setProgress(rsp)
        else
          
        end
      end
    end
  end
  def photoroll_action
    BW::Device.camera.any.picture(media_types: [:image]) do |result|
      photo = result.clone
      Api.postImage photo[:original_image].scale_to_fill(CGSizeMake(1900, 1900)) do |status, rsp|
        if status == 'success'
          setMedia rsp[:id], result[:original_image]
        elsif status == 'progress'
          @layout.setProgress(rsp)
        else

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


