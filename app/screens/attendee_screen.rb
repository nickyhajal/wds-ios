class AttendeeScreen < PM::Screen
  status_bar :light
  attr_accessor :from
  def on_load
    @layout = AttendeeLayout.new(root: self.view)
    @atn = false
    @from = false
    @layout.setController self
    @layout.build
  end
  def setAttendee(atn)
    unless atn.class.to_s.include?('Attendee')
      Api.get 'user', {"user_id" => atn} do |rsp|
        new_atn = Attendee.new(rsp.user)
        setAttendee new_atn
      end
      atn = Attendee.new('default')
    end
    if @layout.nil?
      0.02.seconds.later do
        setAttendee(atn)
      end
    else
      @atn = atn
      @layout.updateAttendee @atn
    end
  end
  def back_action
    close_screen
  end
  def friend_action
    Me.toggleFriendship @atn do
      @layout.reapply!
    end
  end
  def shouldAutorotate
    false
  end
end