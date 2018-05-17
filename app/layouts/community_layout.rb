class CommunityLayout < MK::Layout
  view :communities_view
  def setController(controller)
    @controller = controller
  end
  def init_list
    @community_list = CommunityList.new
    @community_list.setController @controller
    @community_list.setController(@controller)
    self.communities_view = @community_list.view
    @community_list.update_from_store
  end
  def layout
    self.init_list
    root :main do
      add UILabel, :title
      add UIButton, :cancel
      add communities_view, :communities
    end
  end
  def main_style
    background_color "#F2F2EA".uicolor
  end
  def cancel_style
    title "x"
    titleColor Color.dark_gray
    font Font.Vitesse_Medium(18)
    target.addTarget @controller, action: 'close_communities_action', forControlEvents:UIControlEventTouchDown
    constraints do
      left 6
      top.equals(:title).plus(-1)
    end
    target.sizeToFit
  end
  def title_style
    text 'Communities'
    textColor Color.dark_gray
    font Font.Vitesse_Medium(15.0)
    constraints do
      center_x.equals(:superview)
      top Device.isX ? 53 : 26
      height 30
    end
    target.sizeToFit
  end
  def communities_style
    backgroundColor Color.white
    constraints do
      top.equals(:title, :bottom).plus(4)
      height.equals(:superview).minus(58)
      width.equals(:superview)
      left 0
    end
  end
end