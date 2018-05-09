class AttendeeSelectResults < PM::TableScreen
  attr_accessor :controller
  title "Attendees"
  row_height 54, estimated: 84
  def on_load
    @attendees = []
    @width = 0
    @nullMsg = AttendeeSearchNullLayout.new
    @selected = []
    @items = false
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.addSubview @nullMsg.view
    self.tableView.tableFooterView = UIView.alloc.init
    @nullMsg.setMsg("Search WDS Attendees Above to Add them to a Chat")
  end
  def on_appear
    @width = self.tableView.frame.size.width
  end
  def setSelected(selected)
    @selected = selected
    update_table_data
    UIView.setAnimationsEnabled(false)
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled(true)
  end
  def genData(forceGen = false)
    if !@items || forceGen
      @items = [{
        cells: @attendees.map.with_index do |atn, inx|
          {
            title: '',
            cell_class: AttendeeSelectCell,
            action: :show_atn_profile_action,
            arguments: { atn: atn, inx: inx },
            style: {
              width: self.tableView.frame.size.width,
              name: atn['first_name']+' '+atn['last_name'],
              avatar: atn['user_id'],
              selected: @selected.include?(atn['user_id']),
              sep: true
            }
          }
        end
      }]
    end
  end
  def table_data
    genData(true)
  end
  def will_display_cell(cell, index_path)
    cell.backgroundColor = index_path.row % 2 > 0 ? "#FBFBF8".uicolor : "#F7F7F1".uicolor
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.atn = @items[0][:cells][index_path.row][:arguments][:atn]
    cell.controller = self
  end
  def update_results(attendees)
    @attendees = attendees
    if @attendees.length > 0
      @nullMsg.view.hidden = true
    else
      @nullMsg.view.hidden = false
    end
    update_table_data
    UIView.setAnimationsEnabled(false)
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled(true)
  end
  def show_atn_profile_action(args)
    unless @controller.nil?
      @controller.attendeeSelect(args[:atn])
    end
  end
end