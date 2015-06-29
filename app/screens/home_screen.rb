class HomeScreen < PM::Screen
  title 'Dispatch'
  status_bar :light
  attr_accessor :layout
  def on_init
    selected = UIImage.imageNamed("dispatch_icon_selected").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    unselected = UIImage.imageNamed("dispatch_icon").imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal)
    set_tab_bar_item({item: {
        selected: selected,
        unselected: unselected
      },
      title: 'Dispatch'
    })
  end
  def will_appear
    UIApplication.sharedApplication.setStatusBarStyle UIStatusBarStyleLightContent
  end
  def on_load
    @meetup_screen = MeetupScreen.new(nav_bar: false)
    @dispatch_screen = DispatchItemScreen.new(nav_bar: false)
    @attendee_screen = AttendeeScreen.new(nav_bar: false)
    @filters_screen = FiltersScreen.new(nav_bar: false)
    @filters_screen.controller = self
    @filters_screen.init_layout
    @post_screen = PostScreen.new(nav_bar: false)
    @post_screen.controller = self
    @post_screen.init_layout
    @community_screen = CommunityScreen.new(nav_bar: false)
    @community_screen.controller = self
    @community_screen.init_layout
    @layout = HomeLayout.new(root: self.view)
    @dispatch = Disptch.new
    @dispatch.setController self
    @results_table = AttendeeSearchResults.new
    @results_table.controller = self
    @layout.results_view = @results_table.view
    @layout.dispatch = @dispatch
    @layout.dispatch_view = @dispatch.view
    @layout.setResultsTable @results_table
    @layout.setController self
    @layout.build
    @dispatch.initParams({channel_type:'global', layout: @layout, controller: self})
    @dispatch.initFilters(@filters_screen.layout)
    @dispatch.setNewPostsBtn @layout.get(:new_posts), @layout.new_posts_y, self.view
    @post_screen.dispatch = @dispatch
    true
  end
  def open_meetup(meetup)
    @meetup_screen.setMeetup(meetup)
    open_modal @meetup_screen
  end
  def open_profile(user_id)
    @attendee_screen.setAttendee user_id
    open_modal @attendee_screen
  end
  def open_dispatch(item, options = {})
    is_id = options[:is_id] || false
    @dispatch_screen.setItem item, is_id
    open_modal @dispatch_screen
  end
  def load_new_action
    @dispatch.loadNewViaButton
  end
  def show_filters_action
    open_modal @filters_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleDefault)
  end
  def show_post_action
    open_modal @post_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleDefault)
  end
  def show_communities_action
    open_modal @community_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleDefault)
  end
  def close_communities_action
    @community_screen.close_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def select_community_action(community)
    @dispatch.setCommunity(community.interest_id)
    @layout.get(:channel_nav).setHidden false
    @layout.get(:channel_nav).setButtonText 1, community.interest
    @layout.get(:dispatch_nav).setHidden true
    @post_screen.layout.get(:placeholder).text = "Share a post with the "+community.interest+" community"
    @community_screen.close_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def leave_channel_action
    @dispatch.leaveChannel
    @layout.get(:channel_nav).setHidden true
    @layout.get(:dispatch_nav).setHidden false
    @post_screen.layout.get(:placeholder).text = "Type here to share a post!"
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def cancel_filters_action
    @filters_screen.close_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def apply_filters_action
    stored = Store.get('dispatch_filters', true)
    stored = {} unless stored
    filters = @filters_screen.layout
    stored[:twitter] = filters.get(:twitter_selector).selectedSegmentIndex
    stored[:following] = filters.get(:friends_selector).selectedSegmentIndex
    stored[:communities] = filters.get(:communities_selector).selectedSegmentIndex
    stored[:meetups] = filters.get(:meetups_selector).selectedSegmentIndex
    Store.set('dispatch_filters', stored, true)
    @dispatch.setFilters(stored)
    @filters_screen.close_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def show_friends_action
    @layout.get(:attendee_search_layout).setSearch('friends')
  end
  def show_friended_action
    @layout.get(:attendee_search_layout).setSearch('friended me')
  end
  def show_potential_friends_action
    @layout.get(:attendee_search_layout).setSearch("match me")
  end
  def startSearch
    @layout.get(:dispatch).setHidden true
    @layout.get(:dispatch_nav).setHidden true
    @layout.get(:search_nav).setHidden false
  end
  def respondToSearch
    @layout.get(:attendee_results).setHidden false
  end
  def stopSearch
    @layout.get(:search_nav).setHidden true
    @layout.get(:dispatch).setHidden false
    @layout.get(:dispatch_nav).setHidden false
    @layout.get(:attendee_results).setHidden true
  end
  def shouldAutorotate
    false
  end
end