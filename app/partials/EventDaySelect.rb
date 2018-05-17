class EventDaySelect < MK::Layout
  view :day_list
  def layout
    @_day_list = EventTimeListing.new
    @_day_list.setLayout self
    self.day_list = @_day_list.view
    root :main do
      add UIView, :h_line
      add day_list, :day_list
    end
  end

  def fitDate(date)
    if UIScreen.mainScreen.bounds.size.width < 370
      map = {
        'Monday' => 'Mon',
        'Tuesday' => 'Tues',
        'Wednesday' => 'Weds',
        'Thursday' => 'Thu',
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

  def setDaysFromEvents(events)
    @_day_list.setDaysFromEvents(events)
  end

  def setController(controller)
    @controller = controller
  end

  def setLayout(layout)
    @layout = layout
  end

  def main_style
    backgroundColor '#FCFCF3'.uicolor
  end

  def day_heading_style
    font Font.Vitesse_Medium(18)
    textColor '#848477'.uicolor
    text fitDate('Tuesday, August 8th')
    constraints do
      top 10
      left 10
    end
  end

  def h_line_style
    backgroundColor '#E7E7DB'.uicolor
    constraints do
      width get(:main).frame.size.width
      height 1
      left 0
      top 58
    end
  end

  def day_list_style
    backgroundColor '#FCFCF3'.uicolor
    constraints do
      top 0
      left 0
      @dayListHeight = height 58
      width.equals(:superview)
    end
  end

  def setDay(day)
    @_day_list.setDay(day)
  end

  def select_day_tap(day, dayString)
    select_day(day, dayString, true)
  end
  def select_day(day, dayString, isTap = false)
    # @elements[:day_heading].first.hidden = false
    # @elements[:day_select_button].first.hidden = false
    # @elements[:h_line].first.hidden = false
    # @elements[:v_line].first.hidden = false
    # @elements[:day_list].first.hidden = true
    # @elements[:day_heading].first.text = fitDate(dayString)
    @controller.setDay day, fitDate(dayString), isTap
    # @layout.daySelHeight.equals(37)
    #  !@layout.slid_up
      #@layout.daySelTop.plus(46)
    # UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
    #     self.view.layoutIfNeeded  # applies the constraint change
    #     @layout.view.layoutIfNeeded  # applies the constraint change
    #   end, completion: nil)
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

class EventTimeCell < ProMotion::CollectionViewCell
  attr_accessor :day, :width, :controller, :selected

  def setup(cell_data, screen)
    @day = cell_data[:day]
    @selected = cell_data[:selected]
    @controller = cell_data[:controller]
    on_tap do
      @controller.select_day_action(@day)
    end
    super
  end
  def on_reuse
    setNeedsDisplay
  end

  def drawRect(rect)
    # Init
    size = rect.size
    @size = size

    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius: 0.0)
    '#FCFCF3'.uicolor.setFill
    bgPath.fill

    dayName = @day[:dayNameShort].attrd(NSFontAttributeName => @selected ? Font.Karla_BoldItalic(13) : Font.Karla_Italic(13), UITextAttributeTextColor => Color.dark_gray)
    dayNum = @day[:dayNum].attrd(
      NSFontAttributeName => @selected ? Font.Vitesse(17) : Font.Vitesse(17),
      UITextAttributeTextColor => @selected ? Color.bright_tan : Color.dark_gray
    )
    nameBox = dayName.boundingRectWithSize(rect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    numBox = dayNum.boundingRectWithSize(rect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    if @selected
      dotSize = 32
      dot_rect = CGRectMake(rect.size.width/2 - dotSize/2, nameBox.size.height + 8, dotSize, dotSize)
      path = UIBezierPath.bezierPathWithRoundedRect(dot_rect, cornerRadius:(dotSize*0.5))
      Color.cyan.setFill
      path.fill
    end
    dayName.drawInRect(CGRectMake(rect.size.width / 2 - nameBox.size.width / 2, 7, Float::MAX, Float::MAX))
    dayNum.drawInRect(CGRectMake(rect.size.width / 2 - numBox.size.width / 2, 28, Float::MAX, Float::MAX))
  end
end

class EventTimeListing < ProMotion::CollectionScreen
  title "EventTimeListing"
  collection_layout UICollectionViewFlowLayout,
                    direction:                 :horizontal,
                    minimum_line_spacing:      0,
                    minimum_interitem_spacing: 0,
                    item_size:                 [64, 58],
                    section_inset:             [0, 0, 0, 0]

  cell_classes cell: EventTimeCell

  def viewDidLoad
    super
    self.view_did_load if self.respond_to?(:view_did_load)
    @daysList = Assets.get('days')
    @items = []
    @days = false
    @lastUpdate = 0
    daysData
    self.collectionView.backgroundColor = UIColor.clearColor
    self.collectionView.bounces = true
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.alwaysBounceHorizontal = true
  end
  def setLayout(layout)
    @layout = layout
  end
  def setDay(day)
    @selected = day
    reload_data
  end
  def setDays(days)
    now = NSDate.timeIntervalSinceReferenceDate * 1000
    diff = now - @lastUpdate
    if diff > 300
      @lastUpdate = now
      @daysList = days
      daysData
      reload_data
    end
  end
  def setDaysFromEvents(events)
    dayData = Assets.get('dayData')
    list = []
    unless events.nil? || events.keys.nil?
      @length = 0
      events.keys.each do |day|
        if events[day].length > 0
          list << dayData[day]
          @length += 1
        end
      end
    end
    setDays(list)
  end
  def daysData
    days = @daysList
    if days.length > 0
      @selected ||= days[0][:day]
      @days = [
        days.map do |day|
          {day: day, cell_identifier: :cell, controller: self, selected: (@selected == day[:day]), action: :select_day_tap_action, arguments: [ day: day]}
        end
      ]
    else
      @days = []
    end
    @days
  end
  def collection_data
    daysData
  end
  def select_day_action(day)
    @layout.select_day_tap(day[:day], day[:dayStr])
    setDay(day[:day])
    reload_data
  end
  def select_day_tap_action(day)
    @layout.select_day_tap(day[:day], day[:dayStr])
    setDay(day[:day])
    reload_data
  end
end

