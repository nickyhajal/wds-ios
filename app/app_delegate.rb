class AppDelegate < PM::Delegate
    def on_load(app, options)
        appearance
        @feed = FeedScreen.new(nav_bar: false)
        @explore = ExploreScreen.new(nav_bar: true)
        @meetups = MeetupsScreen.new(nav_bar: true)
        @schedule = ScheduleScreen.new(nav_bar: true)
        @more = MoreScreen.new(nav_bar: true)
        open_tab_bar @feed, @schedule, @meetups, @explore, @more
    end
    def appearance
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
