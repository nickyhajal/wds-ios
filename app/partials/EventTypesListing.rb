class EventTypesListing < PM::TableScreen
  title "EventsList"
  attr_accessor :state, :events, :dayStr, :controller
  row_height 144
  def on_load
    # @types = [ 'Meetups', 'Activities', 'Expeditions', 'Academies']
    @types = ['Academies', 'Activities', 'Meetups']
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{cells: getItems}]
  end
  def getItems
    # types  = @types.select do |t|
    #   t != 'Registration'
    # end
    # if !Me.nil? && Me.hasSignedUpForRegistration
    #   types << 'Registration'
    # else
    #   types.unshift('Registration')
    # end
    @types.map do |type|
      make_cell(type)
    end
  end
  def make_cell(event_type)
    @width ||= begin
      @layout.super_width
    end
    {
      title: '',
      cell_class: EventTypeCell,
      # action: :event_type_tap_action,
      arguments: { name: event_type },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        name: event_type,
        width: @width,
        controller: @controller
      }
    }
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.tableView(table_view, cellForRowAtIndexPath:index_path)
    height = cell.getHeight
    height.to_f
  end
end