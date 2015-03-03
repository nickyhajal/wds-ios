class AppDelegate < PM::Delegate
	attr_accessor :login
	def on_load(app, options)
		init_assets
		init_me
		init_db
		init_appearance
		init_screens
		open_loading
		Me.checkLoggedIn
	end
	def open_loading
		open @loading
	end
	def open_login
		open @login
end
	def open_main_app
		open_loading
		Assets.sync do
			open_tab_bar @feed, @schedule, @meetups, @explore, @more
		end
	end
	def init_assets
		Assets.init
	end
	def init_me
		Me.init self
	end
	def init_screens
		@feed = FeedScreen.new(nav_bar: false)
		@explore = ExploreScreen.new(nav_bar: true)
		@meetups = MeetupsScreen.new(nav_bar: true)
		@schedule = ScheduleScreen.new(nav_bar: true)
		@more = MoreScreen.new(nav_bar: true)
		@login = LoginScreen.new(nav_bar: false)
		@loading = LoadingScreen.new(nav_bar:false)
	end
	def init_db
		MotionModel::Store.config(MotionModel::FMDBAdapter.new('wds.db'))
		KeyVal.create_table unless KeyVal.table_exists?
	end
	def init_appearance
		nav_bar = UINavigationBar.appearance
		nav_bar.setBarStyle UIBarStyleBlack
		nav_bar.setBarTintColor "#B0BA1E".to_color
		nav_bar.setTintColor UIColor.whiteColor
		nav_bar.setTitleTextAttributes({
			UITextAttributeTextColor => UIColor.whiteColor,
			UITextAttributeFont => UIFont.fontWithName('Vitesse-Bold', size:18.0)
		})
		tab_bar = UITabBar.appearance
		tab_bar.setBarStyle UIBarStyleBlack
		tab_bar.setTranslucent false
		tab_bar.setBarTintColor "#21170A".uicolor
		tab_bar.setTintColor UIColor.blackColor
		tab_bar_item = UITabBarItem.appearance
		tab_bar_item.setTitleTextAttributes({
				UITextAttributeTextColor => "#BBAD9E".uicolor,
				UITextAttributeFont => UIFont.fontWithName("Karla", size: 12.0)
		}, forState:UIControlStateNormal)
		tab_bar_item.setTitleTextAttributes({
				UITextAttributeTextColor => "#E99533".uicolor
		}, forState:UIControlStateSelected)
	end
end
