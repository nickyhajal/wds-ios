class AppDelegate < PM::Delegate
	attr_accessor :login, :event , :home, :events
	def on_load(app, options)
		$VERSION = '18.1'
		if Device.simulator?
			Stripe.setDefaultPublishableKey('pk_test_8WKTIWKXB6T1eFT9sFqrymCM')
		else
			Stripe.setDefaultPublishableKey('pk_live_v32iH6nfQOgPmKgQiNOrnZCi')
		end
		Fire.init
		if RUBYMOTION_ENV == 'release'
		  Fabric.with([Crashlytics.sharedInstance])
		end
		$IS7 = (UIDevice.currentDevice.systemVersion.floatValue < 8.0)
		$IS8 = (UIDevice.currentDevice.systemVersion.floatValue >= 8.0)
		$IS10 = (UIDevice.currentDevice.systemVersion.floatValue >= 10.0)
		$APP = self
		@tab_bar = false
		init_api
		init_screens
		init_db
		init_assets
		init_me
		init_appearance
		open_loading
		## Used for testing walkthrough ##
		# Store.set('walkthrough', '0')
		step = Me.checkWalkthrough
		if step < 7
			open_walkthrough step
		else
			Me.checkLoggedIn
		end
	end
	def on_activate
		UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
	end
	def init_assets
		Interests.init
		Assets.init
	end
	def init_notifications
		asked = Store.get('asked_for_notifications')
		if asked
			Me.checkDeviceToken
		else
			Store.set('asked_for_notifications', true)
			register_push_notifications
		end
	end
	def init_me
		Me.init self
	end
	def init_screens
		puts 'INIT LOADING'
		@home = HomeScreen.new(nav_bar: false)
		# @explore = ExploreScreen.new(nav_bar: true)
		@chats = ChatsScreen.new(nav_bar: true)
		@events = EventsScreen.new(nav_bar: true)
		@event = EventScreen.new(nav_bar: false)
		@eventTypes = EventTypesScreen.new(nav_bar: true)
		# @event = EventScreen.new(nav_bar: false)
		@dispatchItem = DispatchItemScreen.new(nav_bar: false)
		@profile = AttendeeScreen.new(nav_bar: false)
		@schedule = ScheduleScreen.new(nav_bar: true)
		@login = LoginScreen.new(nav_bar: false)
		@loading = LoadingScreen.new(nav_bar:false)
		puts 'LOADING INITD'
		@walkthrough = WalkthroughScreen.new(nav_bar:false)
		20.seconds.later do
			if BW::Location.enabled? and Store.get('hasLocationPermission', false)
				@explore.location_ping
			end
		end
	end
	def init_api
		Api.init
	end
	def init_db
		MotionModel::Store.config(MotionModel::FMDBAdapter.new('wds.db'))
		KeyVal.create_table unless KeyVal.table_exists?
	end
	def init_appearance
		refresh = UIRefreshControl.appearance
		refresh.setTintColor Color.dark_gray
		refresh.setAttributedTitle(''.attrd({
			UITextAttributeTextColor => Color.bright_green,
			UITextAttributeFont => Font.Karla(12)
		}))
		nav_bar = UINavigationBar.appearance
		nav_bar.setBarStyle UIBarStyleBlack
		nav_bar.setBarTintColor "#0F54ED".to_color
		nav_bar.setTintColor Color.white
		nav_bar.setTitleTextAttributes({
			UITextAttributeTextColor => Color.white,
			UITextAttributeFont => Font.Vitesse_Medium(18)
		})
		tab_bar = UITabBar.appearance
		tab_bar.setBarStyle UIBarStyleBlack
		if $IS8
			tab_bar.setTranslucent false
		end
		tab_bar.setBarTintColor "#262A36".uicolor
		tab_bar.setTintColor UIColor.blackColor
		tab_bar_item = UITabBarItem.appearance
		tab_bar_item.setTitleTextAttributes({
			UITextAttributeTextColor => Color.coffee,
			UITextAttributeFont => Font.Karla(1)
		}, forState:UIControlStateNormal)
		tab_bar_item.setTitleTextAttributes({
			UITextAttributeTextColor => "#FD7021".uicolor
		}, forState:UIControlStateSelected)
		nav_bar_item = UIBarButtonItem.appearance
		nav_bar_item.setTitleTextAttributes({
			UITextAttributeFont => Font.Vitesse_Medium(15)
		}, forState:UIControlStateNormal)
	end
	def showStatusBar
	UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationNone)
	end
	def open_loading
		@loading = LoadingScreen.new(nav_bar:false) if @loading.nil?
		open @loading
	end
	def open_login
		@login = LoginScreen.new(nav_bar:false) if @login.nil?
		open @login
		showStatusBar
	end
	def open_walkthrough(step)
		@walkthrough.setStep step
		open @walkthrough
	end
	def open_tabs
		if @tab_bar
			open_root_screen @tab_bar
			showStatusBar
		else
			open_loading
			Assets.sync do |err|
				@home = HomeScreen.new(nav_bar: false) if @home.nil?
				@explore = ExploreScreen.new(nav_bar: true) if @explore.nil?
				@chats = ChatsScreen.new(nav_bar: true) if @chats.nil?
				@eventTypes = EventTypesScreen.new(nav_bar: true) if @eventTypes.nil?
				@schedule = ScheduleScreen.new(nav_bar: true) if @schedule.nil?
				# NSLog "%@", @schedule.tabBarItem
				# NSLog "%@", @home.tabBarItem
				# NSLog "%@", @eventTypes.tabBarItem
				# NSLog "%@", @chats.tabBarItem
				@tab_bar = open_tab_bar @home, @schedule, @eventTypes, @chats #, @explore
				@tab_bar.tabBar.items.each do |tab|
					tab.imageInsets = UIEdgeInsetsMake(5.0,0,-5.0,0)
				end
				0.05.seconds.later do
					open_notification_content_if_exists
				end
				showStatusBar
				# 0.8.seconds.later do
				# 	init_notifications
				# end
			end
		end
	end
	def open_event(event, from = false)
		open_tab(2)
		@events.open_event(event, from)
	end
	def open_tab(tab)
		open_tabs
		@tab_bar.open_tab(tab)
	end
	def register_push_notifications
	  if UIApplication.sharedApplication.respondsToSelector("registerUserNotificationSettings:")
	    settings = UIUserNotificationSettings.settingsForTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound, categories: nil)
	    UIApplication.sharedApplication.registerUserNotificationSettings(settings)
	  else
	    UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
	  end
	end
	def application(application, didRegisterUserNotificationSettings: notificationSettings)
	  application.registerForRemoteNotifications
	end
	def application(application, didFailToRegisterForRemoteNotificationsWithError: error)
		puts error.inspect
	end
	def application(application, didRegisterForRemoteNotificationsWithDeviceToken: device_token)
		puts 'SAVE DEVICE TOKEN'
		Me.saveDeviceToken device_token
	end
 	def application(application, didReceiveRemoteNotification: data)
		@notification_data = data
		if(application.applicationState == UIApplicationStateActive)
		else
			@notification_data = data
			open_notification_content_if_exists
		end
 	end
	def open_notification_content_if_exists
		if !@notification_data.nil? && @notification_data && @tab_bar
			data = @notification_data
			@notification_data = false
			link = data[:link]
			content = BW::JSON.parse(data[:content])
			if link[0] == '~'
				open_root_screen @tab_bar
				open_tab(@home)
				@home.open_profile content[:from_id]
			elsif link.include? 'dispatch'
				id = link.split('/').last
				open_root_screen @tab_bar
				open_tab(@home)
				@home.open_dispatch id, is_id: true
			elsif link.include? 'message'
				id = link.split('/').last
				open_root_screen @tab_bar
				open_tab(@home)
				@home.open_chat id, data[:title]
			end
		end
	end
	def offline_alert
		UIAlertView.alert("We can't reach WDS HQ", "Looks like you aren't online or our servers are asleep on the job. \n\nPlease try again in a bit!") do
		end
	end
end

class NSDate
	def self.timeAgo
		"hey"
	end
end
class Time
	def self.timeAgo
		"hey"
	end
end