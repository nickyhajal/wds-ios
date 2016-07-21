class AppDelegate < PM::Delegate
	attr_accessor :login, :event , :home, :events
	def on_load(app, options)
		Stripe.setDefaultPublishableKey('pk_test_8WKTIWKXB6T1eFT9sFqrymCM')
   	FIRApp.configure
		if RUBYMOTION_ENV == 'release'
		  Fabric.with([Crashlytics])
		end
		$IS7 = (UIDevice.currentDevice.systemVersion.floatValue < 8.0)
		$IS8 = (UIDevice.currentDevice.systemVersion.floatValue >= 8.0)
		$APP = self
		@tab_bar = false
		init_api
		init_db
		init_assets
		init_me
		init_appearance
		init_screens
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
		@home = HomeScreen.new(nav_bar: false)
		# @explore = ExploreScreen.new(nav_bar: true)
		@events = EventsScreen.new(nav_bar: true)
		@event = EventScreen.new(nav_bar: false)
		@eventTypes = EventTypesScreen.new(nav_bar: true)
		# @event = EventScreen.new(nav_bar: false)
		@dispatchItem = DispatchItemScreen.new(nav_bar: false)
		@profile = AttendeeScreen.new(nav_bar: false)
		@schedule = ScheduleScreen.new(nav_bar: true)
		@more = MoreScreen.new(nav_bar: true)
		@login = LoginScreen.new(nav_bar: false)
		@loading = LoadingScreen.new(nav_bar:false)
		@walkthrough = WalkthroughScreen.new(nav_bar:false)
		# if BW::Location.enabled? && BW::Location.authorized?
		# 	@explore.location_ping
		# end
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
			UITextAttributeTextColor => Color.green,
			UITextAttributeFont => Font.Karla(12)
		}))
		nav_bar = UINavigationBar.appearance
		nav_bar.setBarStyle UIBarStyleBlack
		nav_bar.setBarTintColor "#B0BA1E".to_color
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
		tab_bar.setBarTintColor "#21170A".uicolor
		tab_bar.setTintColor UIColor.blackColor
		tab_bar_item = UITabBarItem.appearance
		tab_bar_item.setTitleTextAttributes({
			UITextAttributeTextColor => Color.orangish_gray,
			UITextAttributeFont => Font.Karla(12)
		}, forState:UIControlStateNormal)
		tab_bar_item.setTitleTextAttributes({
			UITextAttributeTextColor => "#E99533".uicolor
		}, forState:UIControlStateSelected)
		nav_bar_item = UIBarButtonItem.appearance
		nav_bar_item.setTitleTextAttributes({
			UITextAttributeFont => Font.Vitesse_Medium(15)
		}, forState:UIControlStateNormal)
	end
	def open_loading
		open @loading
	end
	def open_login
		open @login
	end
	def open_walkthrough(step)
		@walkthrough.setStep step
		open @walkthrough
	end
	def open_tabs
		if @tab_bar
			open_root_screen @tab_bar
		else
			open_loading
			Assets.sync do |err|
				@tab_bar = open_tab_bar @home, @schedule, @eventTypes #, @explore#, @more
				0.05.seconds.later do
					open_notification_content_if_exists
				end
				0.8.seconds.later do
					init_notifications
				end
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
		Me.saveDeviceToken device_token
	end
	def application(application, didReceiveRemoteNotification: data)
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
			end
		end
	end
	def offline_alert
		UIAlertView.alert("We can't reach WDS HQ", "Looks like you aren't online or our servers are asleep on the job. \n\nPlease try again in a bit!") do
		end
	end
end
