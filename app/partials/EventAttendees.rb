class EventAttendees < PM::TableScreen
  attr_accessor :controller
  title "EventAttendees"
  row_height :auto, estimated: 44
  def on_load
    @attendees = []
    @width = 0
  end
  def on_appear
    @width = self.tableView.frame.size.width
  end
  def table_data
    [{
      cells: @attendees.map do |atn|
        {
          title: '',
          cell_class: AttendeeSearchCell,
          action: :show_atn_profile_action,
          arguments: { atn: atn },
          style: {
            width: self.tableView.frame.size.width,
            name: atn['first_name']+' '+atn['last_name'],
            avatar: atn['user_id'],
            friend: !Me.isFriend(atn['user_id'])
          }
        }
      end
    }]
  end
  def update_results(attendees)
    @attendees = attendees
    update_table_data
  end
  def show_atn_profile_action(args)
    @controller.open_profile(args[:atn]['user_id'])
  end
end