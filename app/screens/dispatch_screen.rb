class DispatchItemScreen < PM::Screen
  status_bar :dark
  def on_load
    @attendee_screen = AttendeeScreen.new(nav_bar: false)
    @layout = DispatchItemLayout.new(root: self.view)
    @item = false if @item.nil?
    @layout.setController self
    @layout.build
    updateLayoutItem
    UIKeyboardWillShowNotification.add_observer(self, 'keyboardWillShow:')
    UIKeyboardWillHideNotification.add_observer(self, 'keyboardWillHide:')
    true
  end
  def open_profile(user_id)
    @attendee_screen.setAttendee user_id
    open_modal @attendee_screen
  end
  def setItem(item, is_id = false)
    if is_id
      Api.get 'feed', {channel_id: item, channel_type: 'feed_item', include_author: true} do |rsp|
        if !rsp.feed_contents[0].nil?
          item = rsp.feed_contents[0]
          loaded_item = DispatchItem.new(item)
          setItem loaded_item
        else
          back_action
        end
      end
      item = DispatchItem.new('default')
    else
      unless item.class.to_s.include?('DispatchItem')
        item = DispatchItem.new(item)
      end
    end
    @item = item
    updateLayoutItem
  end
  def updateLayoutItem
    if !@layout.nil? && @item
      @layout.updateItem(@item)
    end
  end
  def post_comment_action
    inp = @layout.get(:comment_inp)
    btn = @layout.get(:comment_btn)
    text = inp.text
    btn.title = 'Posting'
    Api.post 'feed/comment', {feed_id: @item.feed_id, comment: text} do |rsp|
      btn.title = 'Post'
      inp.text = ''
      inp.resignFirstResponder
      @layout.dispatchContentList.fetchComments(true)
      @layout.dispatchContentList.scrollToBottom
    end
  end
  def back_action
    close_screen
  end
  def like_action
    Me.toggleLike @item.feed_id do
      @layout.reapply!
    end
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def shouldAutorotate
    false
  end
end