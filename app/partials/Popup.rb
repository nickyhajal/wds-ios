class PopupList < PM::TableScreen
  attr_accessor :state, :vals, :controller, :layout
  row_height 40
  def on_load
    @vals = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
  end
  def table_data
    [{cells: getItems}]
  end
  def getItems
    @vals.map do |type|
      make_cell(type)
    end
  end
  def setValues(vals)
    @vals = vals
    update_table_data
  end
  def make_cell(val)
    @width ||= begin
      @layout.super_width
    end
    {
      title: '',
      cell_class: PopupCell,
      action: :select_tap_action,
      arguments: { val: val },
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        val: val,
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


class PopupCell < PM::TableViewCell
  attr_accessor :val, :layout, :width, :controller
  # attr_reader :typeName, :typeImage, :typeStr, :descrStr, :arrowStr
  def will_display
    self.setNeedsDisplay
  end
  def initWithStyle(style, reuseIdentifier:id)
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def singleTap(theEvent)
    @controller.selectVal(@val[:id])
  end
  def getHeight
    50
  end
  ## Draw the TableCell
  def drawRect(rect)
    fontSize = 18
    fontSize = 16 if Device.is4
    @typeStr = @val[:long].attrd({
      NSFontAttributeName => Font.Vitesse_Bold(fontSize),
      UITextAttributeTextColor => Color.dark_gray
    })
    size = self.frame.size
    size.height = Float::MAX
    @typeBox = @typeStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    y = (rect.size.height/2) - (@typeBox.size.height/2)
    @typeStr.drawAtPoint(CGPointMake(20, y))
    path = UIBezierPath.bezierPathWithRoundedRect(
      CGRectMake(0,self.frame.size.height-1, self.frame.size.width, 1), cornerRadius:0.0
    )
    Color.light_gray.setFill
    path.fill
    super
  end
end

# class EventTypeCellInnerView < UIView
#   attr_accessor :cell
#   def initWithFrame(frame)
#     self.opaque = false;
#     super
#   end
#   def drawRect(rect)
#     rect.size.width = @cell.width
#     size = rect.size
#     @cell.typeStr.drawInRect(@cell.typeRect)
#     @cell.descrStr.drawInRect(@cell.descrRect)
#     @cell.arrowStr.drawInRect(@cell.arrowRect)
#   end
# end