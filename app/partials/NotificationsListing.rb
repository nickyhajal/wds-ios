class NotificationsListing < PM::TableScreen
  title "NotificationList"
  attr_accessor :notns, :controller, :layout
  row_height 144
  def on_load
    @notns = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = Color.tan
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{
      cells: @notns
    }]
  end
  def make_cell(notn)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    notn = Notification.new(notn)
    {
      title: '',
      cell_class: NotificationCell,
      arguments: { notn: notn},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        notn: notn,
        width: @width,
        controller: @controller
      }
    }
  end
  def update(notns)
    @notns = []
    notns.each do |notn|
      @notns << make_cell(notn)
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