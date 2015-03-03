class ScheduleCell < PM::TableViewCell
  attr_accessor :event, :what
  def will_display
    puts @event.what
    unless @layout.nil?
      @layout.clear_cells
    end
    if @event.type == 'title'
      @layout = ScheduleTitleCellLayout.new(root: self.contentView)
    else
      @layout = ScheduleCellLayout.new(root: self.contentView)
    end
    #puts event.what
    @layout.setEvent @event
    @layout.build
    @layout.create_cells
  end
  def willMoveToSuperview(_superview)
    event = @event
    puts 'W:'+@what.to_s
  end
end
class ScheduleTitleCellLayout < MK::Layout
  attr_accessor :event
  def layout
    root :main do
      add UIView, :container
    end
  end
  def super_width
    get(:main).frame.size.width
  end
  def title_style
    text @event.start.string_with_format("EEEE, LLLL d")
    textColor "#0073ad".uicolor
    font UIFont.fontWithName("Vitesse-Bold", size:24.0)
    backgroundColor "#FFFFFF".uicolor
    frame [[10,18], [super_width-10,60]]
  end
  def create_cells
    context :container do
      add UILabel, :title
      add UIView, :button_view
    end
  end
  def clear_cells
    container = get(:container)
    container.subviews.makeObjectsPerformSelector("removeFromSuperview")
  end
end
class ScheduleCellLayout < MK::Layout
  def layout
    root :main do
      add UIView, :container
    end
  end
  def create_cells
    context :container do
      add UILabel, :start
      add UIView, :place_shell do
        add UILabel, :place
      end
      add UIView, :what_shell do
        add UILabel, :what 
      end
    end
  end
  def clear_cells
    container = get(:container)
    container.subviews.makeObjectsPerformSelector("removeFromSuperview")
  end
  def setEvent(event)
    @event = event
  end
  def super_width
    get(:main).frame.size.width
  end
  def start_style
    text @event.startTime
    textColor "#FFFFFF".uicolor
    font UIFont.fontWithName("Vitesse-Bold", size:16.0)
    textAlignment UITextAlignmentCenter
    backgroundColor "#e27f1c".uicolor
    frame [[0,0], [95,32]]
  end
  def place_shell_style
    backgroundColor "#f2f2ea".uicolor
    frame [[95,0], [super_width-95,32]]
  end
  def place_style
    text @event.place
    textColor "#EB9622".uicolor
    font UIFont.fontWithName("Karla-Bold", size:17.0)
    frame [[15,0], [super_width-110,32]]
  end
  def what_shell_style
    backgroundColor "#f8f8f2".uicolor
    frame [[0,32],[super_width,40]]
  end
  def what_style
    text @event.what
    textColor "#231f20".uicolor
    font UIFont.fontWithName("Vitesse-Medium", size:18.0)
    frame [[10,0],[super_width-10,40]]
  end
end

  # def tableView(table_view, heightForRowAtIndexPath:index_path)
  #   my_cell = self.promotion_table_data.cell(index_path: index_path)
  #   # calculate based on properties
  #   height = my_cell[:some_property] * something else + padding - moon cycle
  #   height.to_f
  # end
