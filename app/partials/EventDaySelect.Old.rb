class EventDaySelectOld < MK::Layout
  view :day_list
  def layout
    @_day_list = EventTimeListing.new
    @_day_list.setLayout self
    self.day_list = @_day_list.view
    root :main do
      add UILabel, :day_heading
      add UIButton, :day_select_button
      add UIView, :h_line
      add UIView, :v_line
      add day_list, :day_list
    end
  end
  def fitDate(date)
    if UIScreen.mainScreen.bounds.size.width < 370
      map = {
        'Monday' => 'Mon',
        'Tuesday' => 'Tues',
        'Wednesday' => 'Weds',
        'Thursday' => 'Thurs',
        'Friday' => 'Fri',
        'Saturday' => 'Sat',
        'Sunday' => 'Sun'
      }
      map.each do |i, v|
        short = v
        date = date.sub i, short
      end
    end
    date
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
  def day_heading_style
    font UIFont.fontWithName('Vitesse-Medium', size:18)
    textColor "#848477".uicolor
    text fitDate('Tuesday, August 8th')
    constraints do
      top 10
      left 10
    end
  end
  def day_select_button_style
    font UIFont.fontWithName('Vitesse', size:15)
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
  def day_list_style
    constraints do
      top 0
      left 0
      @dayListHeight = height 40
      width.equals(:superview)
    end
    hidden true
  end
  def setDay(day)
    @elements[:day_heading].first.text = fitDate(day)
  end
  def select_day(day, dayString)
    @elements[:day_heading].first.hidden = false
    @elements[:day_select_button].first.hidden = false
    @elements[:h_line].first.hidden = false
    @elements[:v_line].first.hidden = false
    @elements[:day_list].first.hidden = true
    @elements[:day_heading].first.text = fitDate(dayString)
    @controller.setDay day, fitDate(dayString)
    @layout.daySelHeight.equals(37)
    if !@layout.slid_up
      #@layout.daySelTop.plus(46)
    end
    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
        @layout.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
  end
  def open_select_action
    @elements[:day_heading].first.hidden = true
    @elements[:day_select_button].first.hidden = true
    @elements[:h_line].first.hidden = true
    @elements[:v_line].first.hidden = true
    @elements[:day_list].first.hidden = false
    if @layout.slid_up
      @layout.daySelHeight.equals(@layout.super_height - 49)
      @dayListHeight.equals(@layout.super_height - 49)
    else
      if $IS8
        @layout.daySelHeight.equals(@layout.super_height - 46 - 49 - 10)
        @dayListHeight.equals(@layout.super_height - 46 - 49 - 10)
      else
        @layout.daySelHeight.equals(@layout.super_height - 46 - 49 - 60)
        @dayListHeight.equals(@layout.super_height - 46 - 49 - 60)
      end
      #@layout.daySelTop.minus(46)
    end
    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
        @layout.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
  end
end

class EventTimeListingOld < PM::TableScreen
  title "EventTimeListing"
  row_height 44
  def setLayout(layout)
    @layout = layout
  end
  def on_load
    self.tableView.backgroundColor = "#F2F2EA".uicolor
    @days = Assets.get('days')
  end
  def table_data
    [{
      cells: @days.map do |day|
        {
          title: day[:dayStr],
          action: :select_day_action,
          arguments: { day: day},
          properties: {
            selectionStyle: UITableViewCellSelectionStyleNone,
          }
        }
      end
    }]
  end
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.backgroundColor = UIColor.clearColor
    cell.textLabel.font = UIFont.fontWithName('Vitesse-Medium', size:18)
    cell.textLabel.textColor = "#848477".uicolor
  end
  def select_day_action(cell)
    @layout.select_day(cell[:day][:day], cell[:day][:dayStr])
  end
end