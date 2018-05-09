class ChatsListing < PM::TableScreen
  title "ChatsList"
  attr_accessor :items, :controller, :layout
  row_height 144
  def on_load
    @items = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = Color.tan
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{
      cells: @items
    }]
  end
  def make_cell(item)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    {
      title: '',
      cell_class: ChatRowCell,
      arguments: { chat: item},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        chat: item,
        width: @width,
        controller: @controller
      }
    }
  end
  def update(chats)
    @items = []
    chats.each do |chat|
      @items << make_cell(chat)
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