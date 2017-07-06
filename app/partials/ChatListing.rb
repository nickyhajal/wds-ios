class ChatListing < PM::TableScreen
  title "ChatList"
  attr_accessor :chats, :controller, :layout
  row_height 144
  def on_init
    @checkinScreen = false
  end
  def on_load
    @chats = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = Color.tan
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,0,self.tableView.bounds.size.width-8)
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{
      cells: @chats
    }]
  end
  def make_cell(chat)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    {
      title: '',
      cell_class: ChatCell,
      arguments: { chat: chat},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        chat: chat,
        width: @width,
        controller: @controller
      }
    }
  end
  def update(chats)
    @chats = []
    chats.each do |chat|
      @chats << make_cell(chat)
    end
    update_table_data
    UIView.setAnimationsEnabled false
    self.tableView.beginUpdates
    self.tableView.endUpdates
    UIView.setAnimationsEnabled true
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.tableView(table_view, cellForRowAtIndexPath:index_path)
    height = cell.getHeight
    height.to_f
  end
end