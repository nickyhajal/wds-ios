class PlaceTypeSelect < MK::Layout
  view :list
  attr_reader :selected
  def layout
    @_place_list = PlaceTypeListing.new
    @_place_list.setLayout self
    self.list = @_place_list.view
    @selected = false
    root :main do
      add UILabel, :heading
      add UIButton, :select_button
      add UIView, :h_line
      add UIView, :v_line
      add list, :list
    end
  end
  def setController(controller)
    @controller = controller
  end
  def setLayout(layout)
    @layout = layout
  end
  def main_style
    backgroundColor "#FCFCF3".uicolor
  end
  def heading_style
    font Font.Vitesse_Medium(18)
    textColor "#848477".uicolor
    text 'All Places'
    constraints do
      top 10
      left 10
    end
  end
  def select_button_style
    font Font.Vitesse(15)
    titleColor "#848477".uicolor, forState: UIControlStateNormal
    title 'Select'
    target.addTarget self, action:'open_select_action', forControlEvents:UIControlEventTouchUpInside
    constraints do
      top 0.5
      left get(:main).frame.size.width - 100
      width 100
      height 37
    end
  end
  def h_line_style
    backgroundColor "#E7E7DB".uicolor
    constraints do
      width get(:main).frame.size.width
      height 1
      left 0
      top 36
    end
  end
  def v_line_style
    backgroundColor "#E7E7DB".uicolor
    constraints do
      top 0
      width 1
      left get(:main).frame.size.width - 100
      height 37
    end
  end
  def list_style
    constraints do
      top 0
      left 0
      @listHeight = height 40
      width.equals(:superview)
    end
    hidden true
  end
  def setSelected(day)
    @elements[:heading].first.text = day
  end
  def select(cell)
    @selected = cell
    @elements[:heading].first.hidden = false
    @elements[:select_button].first.hidden = false
    @elements[:h_line].first.hidden = false
    @elements[:v_line].first.hidden = false
    @elements[:list].first.hidden = true
    @elements[:heading].first.text = cell[:name]
    @controller.on_select
    @layout.selectorHeight.equals(37)
    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
        @layout.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
  end
  def open_select_action
    @elements[:heading].first.hidden = true
    @elements[:select_button].first.hidden = true
    @elements[:h_line].first.hidden = true
    @elements[:v_line].first.hidden = true
    @elements[:list].first.hidden = false
    @layout.selectorHeight.equals(@layout.super_height - 46 - 49)
    @listHeight.equals(@layout.super_height - 53 - 49)
    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
        @layout.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
  end
end

class PlaceTypeListing < PM::TableScreen
  title "PlaceTypeListing"
  row_height 44
  attr_reader :selected
  def setLayout(layout)
    @layout = layout
  end
  def on_load
    self.tableView.backgroundColor = "#F2F2EA".uicolor
    @types = [
      {id: '0', name: "All Places"},
      {id: '1', name: "WDS Venues"},
      {id: '3', name: "Spots for Food"},
      {id: '4', name: "Bars & Hangouts"},
      {id: '5', name: "Portland Classics"},
      {id: '999', name: "Staff Picks"}
    ]
    @selected = @types[0]
    true
  end
  def table_data
    [{
      cells: @types.map do |type|
        {
          title: type[:name],
          action: :select_action,
          arguments: { payload: type},
          properties: {
            selectionStyle: UITableViewCellSelectionStyleNone
          }
        }
      end
    }]
  end
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.backgroundColor = UIColor.clearColor
    cell.textLabel.font = Font.Vitesse_Medium(18)
    cell.textLabel.textColor = Color.dark_gray
  end
  def select_action(cell)
    @layout.select cell[:payload]
  end
end