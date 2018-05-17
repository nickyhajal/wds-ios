class WalkthroughLayout < MK::Layout
  def setController(controller)
    @controller = controller
  end
  def layout
    @num_panels = 0
    @panels = []
    root :main do
      # add UIImageView, :loading_image
      add ProgressDots, :progress
      add UIScrollView, :shell do
        add UIView, :content
        add UIView, :graphic_shell do
          add UIImageView, :walkthrough_path
        end
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.green
  end
  def loading_image_style
    _width = get(:main).frame.size.width
    _height = get(:main).frame.size.height

    if _width > 400
      imgName = "Default-736h@3x.png"
    elsif _width > 370
      imgName = "Default-667h@2x.png"
    elsif _height > 500
      imgName = "Default-568h@2x.png"
    else
      imgName = "Default@2x.png"
    end
    image imgName.uiimage
    constraints do
      top 0
      width.equals(:superview)
      height.equals(:superview)
      left 0
    end
  end
  def progress_style
    backgroundColor Color.clear
    constraints do
      width.equals(:superview)
      top 30
      left 0
      height 16
    end
  end
  def shell_style
    alpha 0
    delegate self
    backgroundColor Color.clear
    constraints do
      center_x.equals(:superview)
      center_y.equals(:superview).plus(15)
      @shell_width = width 0
      @shell_height = height 0
    end
    pagingEnabled true
    userInteractionEnabled true
    canCancelContentTouches true
    delaysContentTouches false
    showsHorizontalScrollIndicator false
    showsVerticalScrollIndicator false
  end
  def graphic_shell_style
    contentWidth = get(:shell).contentSize.width
    @graph_width = contentWidth - super_width - (super_width)
    constraints do
      width @graph_width
      @graphic_top = top 0
      left (super_width/2) + 6
    end
  end
  def walkthrough_path_style
    imgName = Device.is4 ? 'wt_path_4' : 'wt_path'
    yShift = 70
    if Device.is4
      yShift = 32
    elsif Device.is5
      yShift = 46
    end
    theImage = imgName.uiimage
    theHeight = (theImage.size.height/theImage.size.width) * @graph_width
    image theImage
    constraints do
      width @graph_width
      top 0
      height theHeight
      left 0
      @graphic_top.equals(img_top-yShift)
    end
    add_images
  end
  def content_style
    constraints do
      left 0
      width.equals(:superview)
      top 0
      height.equals(:superview)
    end
    userInteractionEnabled true
    add_welcome
    add_dispatch
    add_communities
    add_meetups
    add_schedule
    add_attendees
    add_finish
    add_transition
    calc_walkthrough_dimensions
  end
  def add_welcome
    add_walkthrough :welcome, 'Hey there!', "Welcome the WDS App!\n\nTo get you off on the right foot, let's go through a quick walkthrough of what you can do here.
    ", {image: "continue_arrow", ratio: 3}
  end
  def add_dispatch
    add_walkthrough :dispatch, 'The Dispatch', "Get to know your fellow WDSers before arriving by posting and chatting on the Dispatch.",{image: "dispatch_big_icon", ratio: 4}
  end
  def add_communities
    add_walkthrough :communities, 'Communities', "Join communities to have discussions with other WDSers about your shared interests.",{image: "community_big_icon", ratio: 3}
  end
  def add_meetups
    title = 'Meetups & Academies'
    if Device.is4
      title = 'Events'
    end
    add_walkthrough :meetups, title, "Browse and RSVP to the wide-range of WDS Activities as well as attendee-hosted meetups.\n\nWe'll even make some suggestions based on your communities.", {image: "meetups_big_icon", ratio: 3}
  end
  def add_schedule
    add_walkthrough :schedule, 'Your Schedule', "Stay on top of your schedule!\n\nEverything you care about is clearly outlined — even your academies, activities and meetups!",{image: "schedule_big_icon", ratio: 4}
  end
  def add_attendees
    add_walkthrough :attendees, 'Browse Attendees', "Search WDSers, browse their profiles and friend them to easily stay connected in the future.\n\nYou can even directly message attendees or groups of attendees.",{image: "attendee_big_icon", ratio: 2}
  end
  def add_finish
    add_walkthrough :finish, "Ready to go?", "You'll need to login with your WDS account to continue.\n\nIf you haven't created one yet, just click the link in your WDS Welcome E-Mail to get started.", {image: "continue_arrow", ratio: 3}
  end
  def add_transition
    add_walkthrough :transition, "", ""
  end
  def add_walkthrough(name, title, content, opts = {})
    _left = super_width * @num_panels
    @panels << {name: name, left: _left}
    add WalkthroughView, name do
      view = get(name)
      frame [[_left, 0], [super_width, super_height]]
      view.setTitle title
      view.setContent content
      view.setTransition if name.to_s == 'transition'
      view.reapply!
    end
    @num_panels += 1
  end
  def add_images
    pathRaised = false
    @panels.each do |panel|
      name = panel[:name]
      _left = panel[:left]
      if name.to_s != 'transition'
        @context = get(:shell)
        add UIImageView, (name.to_s+'_icon').to_sym do
          img = ('wt_'+name.to_s+'_icon').uiimage
          height = (img.size.height / img.size.width) * img_width
          frame [[_left+((super_width/2)-(img_width/2)), img_top], [img_width, height]]
          image img
        end
      end
      unless pathRaised
        pathRaised = true
        get(:shell).bringSubviewToFront(get(:graphic_shell))
      end
    end
  end
  def img_width
    device = Device.type
    padding = 200
    padding = 150 if device == '5'
    super_width - padding
  end
  def img_top
    device = Device.type
    padding = 50
    padding = 20 if device == '4'
    padding = -10 if device == '5'
    super_height - (img_width*2) - padding
  end
  def calc_walkthrough_dimensions
    contentSize = CGSizeMake((@num_panels*(super_width)), super_height-70)
    frame = get(:content).frame
    frame.size = contentSize
    get(:shell).contentSize = contentSize
    get(:progress).setNumDots(@num_panels-1)
  end
  def fade_in
    # http://www.oliverfoggin.com/animate-with-springs/
    get(:shell).alpha = 1
    @shell_width.equals(super_width)
    @shell_height.equals(super_height-70)
    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity:0.1, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded
    end, completion: nil)
  end
  def fade_out
    # http://www.oliverfoggin.com/animate-with-springs/
    @shell_width.equals(0)
    @shell_height.equals(0)
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity:0.1, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded
    end, completion: nil)
  end
  def goToStep(step)
    get(:shell).setContentOffset(CGPointMake(step*(super_width-40), 0), animated:false)
  end
  def scrollViewDidScroll(scrollView)
    if scrollView.frame.size.width > 0
      page = (scrollView.contentOffset.x / scrollView.frame.size.width)
      if page > 6.3
        Store.set('walkthrough', 7)
        @controller.finish_action
      elsif page == page.floor
        Store.set('walkthrough', page)
        get(:progress).setSelected(page)
      end
    end
  end
end