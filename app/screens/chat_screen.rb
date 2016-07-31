class ChatScreen < PM::Screen
  title "Notes"
  status_bar :light
  attr_accessor :layout
  def on_load
    @layout = ChatLayout.new(root: self.view)
    @layout.setController self
    @chat_table = ChatListing.new
    @chat_table.layout = @layout
    @chat_table.controller = self
    @layout.chat_view = @chat_table.view
    @layout.build
    UIKeyboardWillShowNotification.add_observer(self, 'keyboardWillShow:')
    UIKeyboardWillHideNotification.add_observer(self, 'keyboardWillHide:')
    setChat(@atn)
    true
  end
  def setChat(atn)
    @atn = atn
    @user_id = @atn.user_id
    unless @layout.nil?
      @layout.setChat(@atn)
      @layout.reapply!
      update_notes
    end
  end
  def update_notes
    Api.get 'user/notes', {about_id: @user_id} do |rsp|
      if rsp.is_err
        $APP.offline_alert
      else
        if rsp.notes.length > 0
          hideNullMsg
          @notes_table.update rsp.notes
        else
          showNullMsg
        end
      end
    end
  end
  def post_note_action
    note = @layout.get(:note_inp).text
    @layout.get(:note_inp).text = ''
    @layout.get(:note_inp).resignFirstResponder
    Api.post "user/note", {about_id: @user_id, note: note} do |rsp|
      update_notes
    end
  end
  def showNullMsg
    @layout.get(:null_msg).setHidden false
    @layout.get(:chat_list).setHidden true
  end
  def hideNullMsg
    @layout.get(:null_msg).setHidden true
    @layout.get(:chat_list).setHidden false
  end
  def keyboardWillShow(notification)
    @layout.moveInput notification
  end
  def keyboardWillHide(notification)
    @layout.moveInput notification, 'down'
  end
  def close_action
    close_screen
  end
  def shouldAutorotate
    false
  end
end