class HomeLayout < MK::Layout
  attr_accessor :dispatch, :new_posts_y
  view :results_view, :dispatch_view
  def setController(controller)
    @controller = controller
  end
  def setResultsTable(table)
    @results_table = table
  end
  def layout
    root :main do
      add results_view, :attendee_results
      add dispatch_view, :dispatch
      add UIButton, :new_posts
      add AttendeeSearchTitleLayout, :attendee_search_layout
      add DividedNav, :dispatch_nav
      add DividedNav, :channel_nav
      add DividedNav, :search_nav

    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def dispatch_nav_style
    target.setSize super_width, 33
    buttons [
      ['Filter', @controller, 'show_filters_action'],
      ['Communities', @controller, 'show_communities_action'],
      ['Share a Post', @controller, 'show_post_action', {width: 120}]
    ]
    constraints do
      left 0
      top 58
      height 33
      width super_width
    end
  end
  def new_posts_style
    font Font.Karla_Bold(15)
    titleColor Color.light_tan
    backgroundColor Color.green
    hidden true
    target.addTarget @controller, action: 'load_new_action', forControlEvents:UIControlEventTouchDown
    constraints do
      width 120
      height 30
      center_x.equals(:superview)
      @new_posts_y = bottom.equals(:attendee_search_layout, :bottom)
    end
    layer do
      cornerRadius 15
    end
  end
  def channel_nav_style
    target.setSize super_width, 33
    hidden true
    buttons [
      ['x', @controller, 'leave_channel_action', {width: 40}],
      ['Channel', @controller, 'show_communities_action'],
      ['Share a Post', @controller, 'show_post_action', {width: 120}]
    ]
    constraints do
      left 0
      top 58
      height 33
      width super_width
    end
  end
  def search_nav_style
    target.setSize super_width, 33
    hidden true
    buttons [
      ['Friends', @controller, 'show_friends_action'],
      ['Friended You', @controller, 'show_friended_action'],
      ['You\'d Like', @controller, 'show_potential_friends_action']
    ]
    constraints do
      left 0
      top 58
      height 33
      width super_width
    end
  end
  def dispatch_style
    backgroundColor Color.clear
    constraints do
      top 91
      left 0
      width.equals(:superview)
      height.equals(super_height-139)
    end
    @dispatch.setWidth(super_width)
  end
  def attendee_search_layout_style
    get(:attendee_search_layout).setController @controller
    get(:attendee_search_layout).setResultsTable @results_table
    background_color Color.green
    constraints do
      top 0
      left 0
      width.equals(:superview)
      height 58
    end
  end
  def attendee_results_style
    hidden true
    constraints do
      top 91
      left 0
      right "100%"
      height.equals(:superview).minus(58)
    end
  end
  def filters_style
    hidden true
    get(:filters).setController @controller
    constraints do
      left 0
      top 0
      width super_width
      height super_height
    end
  end
  def post_style
    hidden true
    get(:post).setController @controller
    constraints do
      left 0
      top 0
      width super_width
      height super_height
    end
  end
  def communities_style
    hidden true
    get(:communities).setController @controller
    constraints do
      left 0
      top 0
      width super_width
      height super_height
    end
  end
end