class ChatEditScreen < PM::Screen
  status_bar :light
  attr_accessor :layout, :chatters, :chat
  title 'New Chat'
  status_bar :light
  def on_init
    @last_reads = {}
    @chatters = []
    @chatterIds = []
    set_nav_bar_button :right, title: 'Go', action: 'save_chat_action'
  end

  def on_load
    @admins ||= []
    @table = AttendeeSelectResults.new
    @layout = ChatEditLayout.new(root: view)
    @layout.setController self
    @table.controller = self
    @layout.table = @table.view
    @layout.setResults(@table)
    @layout.build
    set_nav_bar_button :right, title: '', action: 'start_chat_action'
    if !@needsSync.nil? and @needsSync
      syncChatters
    end
    true
  end

  def will_appear
    syncInterface
  end
  def on_appear
    syncInterface
  end

  def syncInterface
    if !@chat.nil? && @chat
      self.title = "Chat Admin"
      @layout.get(:placeholder).text = "Search attendees to add to your chat"
      @layout.get(:modal_title).text = "Rename Your Chat"
      set_nav_bar_button :right, title: 'Rename', action: 'rename_action'
    else
      self.title = "New Chat"
      @layout.get(:placeholder).text = "Search attendees to chat with"
      @layout.get(:modal_title).text = "Name Your Chat"
      set_nav_bar_button :right, title: '', action: 'start_chat_action'
    end
    syncChatters
  end

  def setChat(chat)
    if chat
      @chat = chat
      @admins = chat.admins
      @chatters = @chat.participants #.select do |p| p[:user_id] != Me.atn.user_id end
      @chatterIds = @chatters.map do |p| p[:user_id] end
      syncChatters
    end
  end
  def setParent(parent)
    @parent = parent
  end
  def select_atn(atn)
    @selectedAtn = atn
    user_id = atn['user_id']
    adminBtn = @layout.get(:atn_toggle_admin_btn)
    leaveBtn = @layout.get(:atn_leave_btn)
    sep = @layout.get(:atn_sep)
    url = 'https://avatar.wds.fm/' + user_id.to_s + '?width=105'
    puts 'CHAT EDIT'
    @layout.get(:atn_modal_av).setImageWithURL(NSURL.URLWithString(url), placeholderImage: UIImage.imageNamed('default-avatar.png'))
    @layout.get(:atn_modal_title).text = "#{atn['first_name']} #{atn['last_name'][0].upcase}."
    if user_id == Me.atn.user_id
      sep.setHidden true
      adminBtn.setHidden true
      leaveBtn.title = 'Leave Chat'
      @layout.atnModalBoxHeight.equals(110)
    else
      @layout.atnModalBoxHeight.equals(169)
      sep.setHidden false
      adminBtn.setHidden false
      leaveBtn.title = 'Remove from Chat'
      if @admins.include?(user_id)
        adminBtn.title = 'Remove from Admins'
      else
        adminBtn.title = 'Add to Admins'
      end
    end
    @layout.open_atn_modal
  end

  def rename_action
    @layout.open_modal
  end

  def start_chat_action(name = "")
    if @chatters.length == 1
      close({ animated: false })
      @parent.open_chat(Attendee.new(@chatters[0]))
    elsif @chatters.length > 1
      if name.respond_to?('length') && name.length > 0
        with = @chatters.map do |atn| Attendee.new(atn) end
        close({ animated: false })
        @parent.open_group_chat(with, name)
      else
        @layout.open_modal
      end
    end
  end

  def atn_leave_chat
    attendeeSelect(@selectedAtn)
    @layout.close_atn_modal
    if @selectedAtn["user_id"] == Me.atn.user_id
      close to_screen: :root
    end
  end

  def atn_toggle_admin
    user_id = @selectedAtn["user_id"]
    if @admins.include?(user_id)
      @admins.delete_at(@admins.index(user_id))
      if @chat
        @chat.removeAdmin(user_id)
      end
    else
      @admins << user_id
      if @chat
        @chat.addAdmin(user_id)
      end
    end
    syncChatters
    @layout.chattersList.setAdmins(@admins)
    @layout.close_atn_modal
  end

  def attendeeSelect(atn)
    user_id = atn["user_id"]
    if @chatterIds.include?(user_id)
      @chatterIds.delete_at(@chatterIds.index(user_id))
      @chatters = @chatters.select { |c| c["user_id"] != user_id }
      if !@chat.nil? && @chat
        @chat.removeParticipant(atn)
      end
    else
      @chatterIds.unshift(user_id)
      @chatters.unshift(atn)
      unless @layout.nil?
        @layout.clearSearchInput
      end
      if !@chat.nil? && @chat
        @chat.addParticipant(Attendee.new(atn), 'update')
      end
    end
    syncChatters
  end
  def syncChatters
    if @table.nil?
      @needsSync = true
    else
      @table.setSelected(@chatterIds)
      0.3.seconds.later do
        @layout.chattersList.setChatters(@chatters)
      end
      if !@chat.nil? && @chat
          set_nav_bar_button :right, title: 'Rename', action: 'rename_action'
      else
        if @chatterIds.length > 0
          set_nav_bar_button :right, title: 'Start', action: 'start_chat_action'
        else
          set_nav_bar_button :right, title: '', action: 'start_chat_action'
        end
      end
      if !@admins.include?(Me.atn.user_id)
        @admins << Me.atn.user_id
      end
      @layout.updateChatters
      @layout.chattersList.setAdmins(@admins)
    end
  end
  def on_disappear
    @chat = false
    @chatters = []
    @chatterIds = []
    @layout.close_modal
    syncInterface
  end

  def shouldAutorotate
    false
  end
end
