class ChatDetailScreen < PM::Screen
  status_bar :light
  attr_accessor :layout, :chatters, :chat
  title 'Chat Details'
  status_bar :light
  def on_init
    @chatters = []
    @chatterIds = []
  end

  def on_load
    @admins ||= []
    @layout = ChatDetailLayout.new(root: view)
    @layout.setController self
    @layout.build
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
    # Do nothing on tap of a chatter
  end

  def leave_action
    user_id = Me.atn.user_id
    if @chatterIds.include?(user_id)
      @chatterIds.delete_at(@chatterIds.index(user_id))
      @chatters = @chatters.select { |c| c["user_id"] != user_id }
      if !@chat.nil? && @chat
        @chat.removeParticipant({"user_id" => user_id})
      end
    end
    close to_screen: :root
  end

  def syncChatters
    if @layout.nil?
      @needsSync = true
    else
      0.1.seconds.later do
        @layout.chattersList.setChatters(@chatters)
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
    syncInterface
  end

  def shouldAutorotate
    false
  end
end
