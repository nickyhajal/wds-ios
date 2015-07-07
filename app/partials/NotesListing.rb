class NotesListing < PM::TableScreen
  title "NotesList"
  attr_accessor :notes, :controller, :layout
  row_height 144
  def on_init
    @checkinScreen = false
  end
  def on_load
    @notes = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = Color.tan
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{
      cells: @notes
    }]
  end
  def make_cell(note)
    @width = !@layout.nil? && !@layout.super_width.nil? ? @layout.super_width : 400
    {
      title: '',
      cell_class: NoteCell,
      arguments: { note: note},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        note: note,
        width: @width,
        controller: @controller
      }
    }
  end
  def update(notes)
    @notes = []
    notes.each do |note|
      @notes << make_cell(note)
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