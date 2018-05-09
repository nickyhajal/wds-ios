class ExploreLayout < MK::Layout
  attr_accessor :selectorHeight
  view :place_view
  def setController(controller)
    @controller = controller
  end
  def layout
    root :main do
      add UIView, :sub_nav do
        # add UISegmentedControl, :subview_selector
        add UISegmentedControl, :sort_selector
      end
      add place_view, :place_list
      add PlaceTypeSelect, :selector
      add PermissionLayout, :permission
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
  def sub_nav_style
    background_color Color.bright_green
    constraints do
      width.equals(:superview)
      height 46
      @subNavTop = top 63
      left 0
    end
  end
  def subview_selector_style
    target.segmentedControlStyle = UISegmentedControlStyleBar
    target.insertSegmentWithTitle 'List', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Map', atIndex:1, animated:false
    target.selectedSegmentIndex = 0
    target.addTarget @controller, action: 'change_view_action:', forControlEvents:UIControlEventValueChanged
    tintColor Color.white
    attributes = {
      UITextAttributeFont => UIFont.fontWithName('Karla-Bold', size:15)
    }
    titleTextAttributes attributes, forState:UIControlStateNormal
    constraints do
      width ((super_width/2)-10)
      left 5
      height 30
      top 8
    end
    target.sizeToFit
  end
  def sort_selector_style
    target.segmentedControlStyle = UISegmentedControlStyleBar
    target.insertSegmentWithTitle 'Sort by Distance', atIndex:0, animated:false
    target.insertSegmentWithTitle 'Sort by Check Ins', atIndex:1, animated:false
    target.selectedSegmentIndex = 0
    target.addTarget @controller, action: 'change_sort_action:', forControlEvents:UIControlEventValueChanged
    tintColor Color.white
    attributes = {
      UITextAttributeFont => UIFont.fontWithName('Karla-Bold', size:15)
    }
    titleTextAttributes attributes, forState:UIControlStateNormal
    constraints do
      # width ((super_width/2)-5)
      # left.equals(:subview_selector, :right).plus(5)
      width super_width - 20
      left 10
      height 30
      top 8
    end
    target.sizeToFit
  end
  def selector_style
    get(:selector).setController @controller
    get(:selector).setLayout self
    constraints do
      width.equals(:superview)
      top.equals(:sub_nav, :bottom)
      @selectorHeight = height 37
      left 0
    end
  end
  def place_list_style
    backgroundColor "#F2F2EA".uicolor
    constraints do
      left 0
      right "100%"
      @listTop = top 146
      if $IS8
        @listHeight = height.equals(:superview).minus(146)
      else
        @listHeight = height.equals(:superview).minus(193)
      end
    end
  end
  def permission_style 
    hidden true
    constraints do
      top.equals(40)
      left.equals(0)
      width.equals(super_width)
      height.equals(super_height  - 40)
    end
  end
end