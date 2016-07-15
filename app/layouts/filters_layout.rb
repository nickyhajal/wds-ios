class FiltersLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add UILabel, :title
      add UIView, :twitter_row do
        add UILabel, :twitter
        add UISegmentedControl, :twitter_selector
      end
      add UIView, :friends_row do
        add UILabel, :friends
        add UISegmentedControl, :friends_selector
      end
      add UIView, :communities_row do
        add UILabel, :communities
        add UISegmentedControl, :communities_selector
      end
      add UIView, :events_row do
        add UILabel, :events
        add UISegmentedControl, :events_selector
      end
      add UIButton, :submit
      add UIButton, :cancel
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def title_style
    text 'Dispatch Filters'
    textColor Color.dark_gray
    font Font.Vitesse_Medium(15.0)
    constraints do
      center_x.equals(:superview)
      top 23
      height 30
      width 120
    end
    target.sizeToFit
  end
  def twitter_row_style
    row
    backgroundColor Color.white(0.6)
    constraints do
      top 58
    end
  end
  def twitter_style
    label
    text 'Twitter Posts'
  end
  def twitter_selector_style
    target.insertSegmentWithTitle 'Show', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Hide', atIndex:1, animated:false
    #target.addTarget @controller, action: 'twitter_selector_action:', forControlEvents:UIControlEventValueChanged
    selector
  end
  def friends_row_style
    row
    backgroundColor Color.white(0.4)
    constraints do
      top.equals(:twitter_row, :bottom)
    end
  end
  def friends_style
    label
    text 'Attendees'
  end
  def friends_selector_style
    target.insertSegmentWithTitle 'Show All', atIndex:0, animated:false
    target.insertSegmentWithTitle 'My Friends', atIndex:1, animated:false
    #target.addTarget @controller, action: 'friends_selector_action:', forControlEvents:UIControlEventValueChanged
    selector
  end
  def communities_row_style
    row
    backgroundColor Color.white(0.6)
    constraints do
      top.equals(:friends_row, :bottom)
    end
  end
  def communities_style
    label
    text 'Communities'
  end
  def communities_selector_style
    target.insertSegmentWithTitle 'All', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Mine', atIndex:1, animated:false
    target.insertSegmentWithTitle 'None', atIndex:2, animated:false
    target.selectedSegmentIndex = 0
    #target.addTarget @controller, action: 'communities_selector_action:', forControlEvents:UIControlEventValueChanged
    selector
  end
  def events_row_style
    row
    backgroundColor Color.white(0.4)
    constraints do
      top.equals(:communities_row, :bottom)
    end
  end
  def events_style
    label
    text 'Events'
  end
  def events_selector_style
    target.insertSegmentWithTitle 'All', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Mine', atIndex:1, animated:false
    target.insertSegmentWithTitle 'None', atIndex:2, animated:false
    target.selectedSegmentIndex = 0
    #target.addTarget @controller, action: 'meetups_selector_action:', forControlEvents:UIControlEventValueChanged
    selector
  end
  def submit_style
    backgroundColor Color.orange
    title "Apply Filters"
    titleColor Color.white
    font Font.Karla_bold(16.0)
    target.addTarget @controller, action: 'apply_filters_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 0
      top.equals(:events_row, :bottom)
      width.equals(:superview)
      height 40
    end
  end
  def cancel_style
    title "x"
    titleColor Color.dark_gray
    font Font.Vitesse_Medium(18)
    target.addTarget @controller, action: 'cancel_filters_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 6
      top 22
    end
    target.sizeToFit
  end
  def selector
    target.selectedSegmentIndex = 0
    target.segmentedControlStyle = UISegmentedControlStyleBar
    tintColor Color.orange
    attributes = {
      UITextAttributeFont => Font.Karla_Bold(15)
    }
    titleTextAttributes attributes, forState:UIControlStateNormal
    target.sizeToFit
    constraints do
      width 170
      right -10
      height 30
      center_y.equals(:superview)
    end
  end
  def label
    constraints do
      left 10
      width 190
      height 30
      center_y.equals(:superview)
    end
    font Font.Vitesse_Medium(16.0)
    textColor Color.dark_gray
  end
  def row
    constraints do
      width.equals(:superview)
      height 50
      left 0
    end
  end
end