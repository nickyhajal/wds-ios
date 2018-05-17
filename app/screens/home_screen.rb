
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
      title: ''
    })
  end
  def will_appear
    UIApplication.sharedApplication.setStatusBarStyle UIStatusBarStyleLightContent
  end
  def on_load
    @event_screen = EventScreen.new(nav_bar: false)
    @notifications_screen = NotificationsScreen.new(nav_bar: false)
    @dispatch_screen = DispatchItemScreen.new(nav_bar: false)
    @attendee_screen = AttendeeScreen.new(nav_bar: false)
    @atnstory_screen = AtnStoryScreen.new(nav_bar: false)
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
    @chat_screen = ChatScreen.new(nav_bar: false)
    @cart = CartScreen.new(nav_bar: false)
    Fire.watch "value", "/state" do |rsp|
      unless rsp.value.nil?
        $STATE = rsp.value
        @dispatch.update_content([])
      end
    end
    2.0.seconds.later do
      $PRESALES = {fresh: [], used:[]}
      Fire.query "added", "/presales", [{type: 'limitLast', val: 30}] do |rsp|
        unless rsp.value.nil?
          now = NSDate.new.timeIntervalSince1970
          unless rsp.value[:created_at].nil?

            # If it's less than 20 minutes old, it's fresh
            if (now - (rsp.value[:created_at] / 1000)) < 12000
              $PRESALES[:fresh] << rsp.value
            else
              $PRESALES[:used] << rsp.value
            end
          end
        end
      end
    end
    0.4.seconds.later do
      open_notification_permission_primer
    end
    Assets.preload(UIImage.imageNamed("faded_overlay.png"))
    # @img.setImage(UIImage.imageNamed(img))

    ## This is to auto-open the cart for testing
    # 0.5.seconds.later do
    #   Assets.getSmart 'academy', do |academies, status|
    #     @cart = CartScreen.new(nav_bar: false)
    #     @cart.setProduct('academy', Event.new(academies['2016-08-12'][1]))
    #     open_modal @cart
    #   end
    # end
    true
  end
  def open_notification_permission_primer
      asked = Store.get('asked_for_notifications')
      asked = 0 if !asked
      token = Store.get('device_token')
      now = NSDate.new.timeIntervalSince1970
      diff = now.to_f - asked.to_f
      if !token && diff > 432000
        Store.set('asked_for_notifications', now)
        str = "We use notifications to send *important event updates*, *attendee messages* and *fun, secret surprises*.\n\nActivate them to make sure you don't miss out!"
        modal = {
          title: 'Enable Notifications!',
          content: str,
          close_on_yes: true,
          image: "notificationIcon".uiimage,
          yes_text: "Yup, enable them!",
          no_text: "No, thanks.",
          yes_action: 'request_notification_action',
          controller: self
        }
        @layout.get(:noti_permission).open(modal)
      else
        Me.checkDeviceToken
      end
  end
  def request_notification_action(item)
    if UIApplication.sharedApplication.respondsToSelector("registerUserNotificationSettings:")
	    settings = UIUserNotificationSettings.settingsForTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound, categories: nil)
	    UIApplication.sharedApplication.registerUserNotificationSettings(settings)
	  else
	    UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
	  end
  end
  def open_event(event)
    @event_screen.setEvent(event)
    open_modal @event_screen
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
  def open_chat(pid, name = false)
    @chat_screen.setChatFromPid({ pid: pid, name: name })
    open_modal @chat_screen
  end
  def open_notifications
    @notifications_screen.sync
    open_modal @notifications_screen
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
    stored[:events] = filters.get(:events_selector).selectedSegmentIndex
    stored[:photos] = filters.get(:photos_selector).selectedSegmentIndex
    Store.set('dispatch_filters', stored, true)
    @dispatch.setFilters(stored)
    @dispatch.showPhotos(stored[:photos])
    @filters_screen.close_screen
    UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
  end
  def show_friends_action
    @layout.get(:attendee_search_layout).setSearch('friends')
  end
  def show_friended_action
    @layout.get(:attendee_search_layout).setSearch('friended me')
  end
  def tckt_purchase_action
    @cart.setProduct('wds2018', {})
    @cart.setPurchasedCallback(self, 'tckt_purchased', false)
    @cart.setTerms('Each ticket includes 1 complimentary, non-transferable WDS Academy, priority booking at the WDS Hotel, and other discounts and benefits.

 Tickets are non-refundable. Name changes and ticket transfers are permitted up to 60 days prior to the event for a $100 fee. A late transfer option will be available at a higher cost.')
    open_modal @cart
  end
  def open_atn_story_action
    open_modal @atnstory_screen
  end
  def post_tckt_action
    @dispatch.hideFirst
    Store.set('preorder17', 'post-hidden')
  end
  def tckt_purchased
    Store.set('preorder17', 'purchased')
    Me.atn.attending17 = 1
    @dispatch.update_content([])
  end
  def show_potential_friends_action
    @layout.get(:attendee_search_layout).setSearch("match me")
  end
  def startSearch
    @dispatch.active = false
    @layout.get(:dispatch).setHidden true
    @layout.get(:dispatch_nav).setHidden true
    @layout.get(:search_nav).setHidden false
    @layout.get(:attendee_results).setHidden false
  end
  def respondToSearch
    @layout.get(:attendee_results).setHidden false
  end
  def stopSearch
    @dispatch.active = true
    @layout.get(:search_nav).setHidden true
    @layout.get(:dispatch).setHidden false
    @layout.get(:dispatch_nav).setHidden false
    @layout.get(:attendee_results).setHidden true
  end
  def shouldAutorotate
    false
  end
end