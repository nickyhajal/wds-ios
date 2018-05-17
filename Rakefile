# -*- coding: utf-8 -*-


### CRASH SYMBOLICATING
# ./symbolicatecrash -o /nky/wds-ios/crashes/l3.3.txt /nky/wds-ios/crashes/logs3/4.crash
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
  require 'ProMotion'
  require 'motion-support'
  require 'sugarcube'
  require 'sugarcube-nsdate'
  require 'sugarcube-nsdata'
  require 'sugarcube-timer'
  require 'sugarcube-foundation'
  require 'sugarcube-attributedstring'
  require 'sugarcube-numbers'
  require 'sugarcube-animations'
  require 'sugarcube-notifications'
  require 'sugarcube-localized'
  require 'sugarcube-color'
  require 'sugarcube-gestures'
  require 'sugarcube-ui'
  require 'sugarcube-factories'
  require 'sugarcube-image'
  require 'bubble-wrap'
  require "bubble-wrap/location"
  require 'bubble-wrap/camera'
  require 'motion-kit'
  require 'motion_model'
  require 'motion_model/array'
  require 'motion_model/sql'
  require 'afmotion'
  require 'motion-cocoapods'
  require 'map-kit-wrapper'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  force_64bit_only!(app)
  define_icon_defaults!(app)
  app.name = 'WDS App'
  app.frameworks += ["QuartzCore", "CoreImage", "MapKit"]
  app.identifier = 'com.worlddominationsummit.wdsios'


  ## UPDATE APP DELEGATE VERSION
  app.version = '18.1'
  app.short_version = '2.3.0'
  app.detect_dependencies = true

  app.development do
    app.codesign_certificate = MotionProvisioning.certificate(platform: :ios, type: :development)
    app.provisioning_profile = MotionProvisioning.profile(bundle_identifier: app.identifier,
                           app_name: app.name,
                           platform: :ios,
                           type: :development)
  end
  app.release do
    app.codesign_certificate = MotionProvisioning.certificate(platform: :ios, type: :distribution)
    app.provisioning_profile = MotionProvisioning.profile(bundle_identifier: app.identifier,
                           app_name: app.name,
                           platform: :ios,
                           type: :distribution)
    # app.provisioning_profile = '/nky/secure_files/WDS_App_Production.mobileprovision'
    # app.codesign_certificate = 'iPhone Distribution: Nicholas Hajal (B2D7N48CG9)'
    app.entitlements['beta-reports-active'] = true
  end
  app.fabric do |config|
    config.api_key = "3a3d44766f7f51cc70d2bf6049548f46da107e09"
    config.build_secret = "b174cc4665c9f14925fd436158f0f20f57225f1e2eacfa36258bf169e8ce9c1e"
    config.kit 'Crashlytics'
  end
  app.entitlements['application-identifier'] = "#{app.seed_id}.#{app.identifier}"
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.info_plist['NSLocationAlwaysUsageDescription'] = 'We use your location to help you explore Portland and connect with other WDSers.'
  app.info_plist['NSLocationWhenInUseUsageDescription'] = 'We use your location to help you explore Portland and connect with other WDSers.'
  app.info_plist['NSCameraUsageDescription'] = 'We use your camera to allow you to share photos with WDS Attendees and to make adding credit cards easy.'
  app.info_plist['NSPhotoLibraryUsageDescription'] = 'We use your photos to allow you to share photos with WDS Attendees and to make adding credit cards easy.'
  app.info_plist['UIStatusBarHidden'] = true
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['ITSAppUsesNonExemptEncryption'] = false
  app.libs += ['/usr/lib/libsqlite3.dylib']
  # app.vendor_project 'vendor/FMDB', :static
  # app.vendor_project 'vendor/MMMarkdown/Source', :static
  app.interface_orientations = [:portrait]
  # app.icons = ['Icon.png', 'Icon@2x.png', 'Icon@3x.png']
  app.deployment_target = "11.0"
  app.fonts = ['Graphik-Medium.ttf', 'Graphik-RegularItalic.ttf', 'Graphik-SemiboldItalic.ttf', 'Graphik-Semibold.ttf', 'Produkt-Semibold.ttf', 'Karla-Regular.ttf', 'Karla-BoldItalic.ttf', 'Karla-Italic.ttf', 'Karla-Bold.ttf', 'Vitesse-Bold.otf', 'Vitesse-Book.otf', 'Vitesse-Light.otf', 'Vitesse-Medium.otf', 'ionicons.ttf']
  app.pods do
    pod 'SDWebImage', '~>3.7'
    pod 'SZTextView'
    pod 'ionicons', '~>2.1.1'
    pod 'OpenInChrome'
    pod 'MMMarkdown'
    pod 'FMDB'
    pod 'Firebase'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Stripe'
    pod 'UIImage-Resize'
    pod 'MCSMKeychainItem'
    pod 'CardIO'
  end

  # Push Notifications
  app.development do
    app.entitlements["aps-environment"] = "development"
  end
  app.release do
    app.entitlements["aps-environment"] = "production"
  end
  app.ordered_build_files.clear
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/shortcut.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/lib/bubble-wrap/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/util/deprecated.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/json.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/string.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ns_index_path.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ns_user_defaults.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/app.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ns_url_request.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/device.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/pollute.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ns_notification_center.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/kvo.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/persistence.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/time.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/device/screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ios/ns_index_path.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ios/app.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/ios/device.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/util/constants.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/device/ios/camera.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/device/ios/camera_wrapper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/core/device/ios/screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_bar_button_item.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_control_wrapper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_view_wrapper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_view_controller_wrapper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/pollute.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_activity_view_controller_wrapper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ui/ui_alert_view.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/location/location.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/location/pollute.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/bubble-wrap-1.9.6/motion/ios/8/location_constants.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/parse.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/decode.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/format.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/cgi.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/encode.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/mdurl-rb-1.0.5/lib/mdurl-rb/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/nsnumber.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/date_parser.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/nsdate.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/fixnum.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdate/nsdate_delta.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdata/nsurl.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdata/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-nsdata/nsdata.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-nsdata/uiimage.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-nsdata/nsdata.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-timer/timer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsarray.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsurl.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsset.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsindexset.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsindexpath.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-foundation/nsorderedset.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-attributedstring/nsattributedstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-attributedstring/nsattributedstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-coregraphics/core_graphics.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-animations/caanimation.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-animations/calayer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-animations/uiview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-animations/animation_chain.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-notifications/notifications.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-localized/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-localized/nserror.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/nsarray.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/uiimage.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/symbol.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/uicolor.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-color/fixnum.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-gestures/gestures.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-ui/calayer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-ui/frameable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uiview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uiwebview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uilabel.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uiviewcontroller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uiimage.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/symbol.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/nsstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/frameable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uipickerview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/nsattributedstring.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uibutton.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-ui/uifont.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uibarbuttonitem.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uiactivityindicatorview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uilabel.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uitabbaritem.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uitableviewcell.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uisegmentedcontrol.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uiblureffect.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uialertcontroller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uitableview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uibutton.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uialertview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/uiactionsheet.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-factories/nserror.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-image/cifilter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-image/cicolor.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-image/uiimage.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-image/uicolor.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-image/ciimage.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/properties/Any/regex.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/version.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/categories/Cf/regex.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/categories/Z/regex.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/categories/Cc/regex.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/uc.micro-rb-1.0.5/lib/uc.micro-rb/categories/P/regex.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/linkify-it-rb-2.0.3/lib/linkify-it-rb/re.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/linkify-it-rb-2.0.3/lib/linkify-it-rb/version.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/linkify-it-rb-2.0.3/lib/linkify-it-rb/index.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/token.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/presets/default.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/presets/zero.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/presets/commonmark.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/entities.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/string.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/html_re.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/utils.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/html_blocks.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/common/simpleidn.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/helpers/parse_link_title.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/helpers/parse_link_destination.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/helpers/parse_link_label.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/helpers/helper_wrapper.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/index.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/parser_block.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/inline.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/block.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/linkify.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/state_core.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/replacements.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/normalize.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_core/smartquotes.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/parser_core.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/renderer.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/ruler.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/version.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/table.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/state_block.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/reference.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/paragraph.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/blockquote.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/heading.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/code.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/lheading.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/hr.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/fence.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/list.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_block/html_block.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/image.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/newline.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/emphasis.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/text.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/backticks.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/entity.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/balance_pairs.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/state_inline.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/text_collapse.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/strikethrough.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/autolink.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/html_inline.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/link.rb"
  # app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-markdown-it-8.4.1.1/lib/motion-markdown-it/rules_inline/escape.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/ion_in_motion-f2561a3adccc/lib/ion/ion.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/test_suite_delegate.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/map_type.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/core_location_data_types.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/zoom_level.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/map_kit_data_types.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/map-kit-wrapper-0.0.5/lib/map-kit-wrapper/map_view.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion_print-1.2.0/lib/../motion/motion_print/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion_print-1.2.0/lib/../motion/motion_print/core_ext/kernel.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion_print-1.2.0/lib/../motion/motion_print/core_ext/string.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion_print-1.2.0/lib/../motion/motion_print/motion_print.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion_print-1.2.0/lib/../motion/motion_print/colorizer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/_stdlib/array.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/concern.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/descendants_tracker.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/callbacks.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/kernel/singleton_class.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/wrap.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/access.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/conversions.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/extract_options.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/grouping.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/array/prepend_and_append.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/class/attribute.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/class/attribute_accessors.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/aliasing.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/introspection.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/anonymous.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/reachable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/attribute_accessors.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/attr_internal.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/delegation.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/module/remove_method.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/integer/multiple.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/integer/inflections.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/integer/time.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/ns_dictionary.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/to_param.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/deep_merge.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/except.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/indifferent_access.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/keys.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/reverse_merge.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/slice.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/hash/deep_delete_if.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/hash_with_indifferent_access.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/duration.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/numeric/bytes.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/numeric/conversions.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/numeric/time.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/_stdlib/cgi.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/acts_like.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/blank.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/deep_dup.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/duplicable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/inclusion.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/try.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/instance_variables.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/to_json.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/object/to_query.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/range/include_range.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/range/overlaps.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/ns_string.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/access.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/behavior.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/exclude.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/filters.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/indent.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/starts_ends_with.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/inflections.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/string/strip.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/_stdlib/date.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/_stdlib/time.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/time/acts_like.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/date_and_time/calculations.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/time/calculations.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/time/conversions.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/date/acts_like.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/date/calculations.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/date/conversions.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/enumerable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/metaclass.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/core_ext/regexp.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/inflector/inflections.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/inflector/methods.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/inflections.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/logger.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/number_helper.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-support-1.2.0/motion/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/all/sugarcube/log.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/all/sugarcube/look_in.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube/log.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nsnotification.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nsurl.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nslayoutconstraint.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nsset.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/calayer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nsindexpath.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/cocoa/sugarcube-to_s/nserror.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uiview.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uilabel.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uitouch.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uiviewcontroller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uitextfield.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uievent.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/sugarcube-3.4.2/lib/ios/sugarcube-to_s/uicolor.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/calculator/calculator.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/calculator/frame_calculator.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/calculator/origin_calculator.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/calculator/size_calculator.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/calculator/view_calculator.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/calculator/calculate.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/util.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/motion-kit.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/object.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/helpers/base_layout_class_methods.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/helpers/base_layout.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/helpers/tree_layout.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit/helpers/parent.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/constraints/constraint.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/constraints/point_constraint.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/constraints/constraints_target.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/constraints/constraints_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/constraints/size_constraint.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/cocoa_util.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/helpers/calayer_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/helpers/sugarcube_compat.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/helpers/calayer_frame_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/helpers/accessibility_compat.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-cocoa/helpers/cagradientlayer_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/dummy.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/ios_util.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uiview_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uibutton_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/deprecated.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/constraints_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uiview_autoresizing_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uiview_constraints_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uiview_gradient_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/layout_device.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/layout_orientation.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-kit-1.1.1/lib/motion-kit-ios/helpers/uiview_frame_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/motion-require-0.2.0/motion/ext.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/http_result.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/http.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/serializer.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/client_shared.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/http_client.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/session_client.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/operation.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/patch/UIImageView_url.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/afmotion-2.6/lib/afmotion/patch/NSString_NSUrl.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/ext.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/date_parser.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/validatable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/input_helpers.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/store.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/inheritance.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/column.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/model_casts.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/model.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/formotion.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/model/transaction.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/base_db_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/base_model_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/support/support.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/screen/nav_bar_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/screen/screen_navigation.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/screen/status_bar_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/styling/styling.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/tabs/tabs.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/ipad/split_screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/screen/screen_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/view_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/screen/screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/stubs/dummy_image_view.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/stubs/dummy_view.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/collection_view_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/collection_builder.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/collection_class_methods.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/table_utils.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/collection.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/cell/collection_view_cell_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/collection_screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/data/collection_data_builder.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/collection/data/collection_data.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/logger/logger.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/navigation_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/ns_url.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/ns_string.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/tab_bar_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/split_view_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/web/web_screen_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/web/web_screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/repl/live_reloader.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/repl/repl.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/delegate/delegate_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/delegate/delegate_parent.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/delegate/delegate.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/pro_motion.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/table_class_methods.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/table_builder.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/extensions/searchable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/extensions/refreshable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/extensions/indexable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/extensions/longpressable.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/table.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/grouped_table.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/table_view_controller.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/table_screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/data/table_data_builder.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/data/table_data.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/grouped_table_screen.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/collection_view_cell.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/table/cell/table_view_cell_module.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/cocoatouch/table_view_cell.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/ProMotion-2.8.0/lib/ProMotion/version.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/array/array_model_persistence.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/array/array_model_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/array/array_finder_query.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sql_db_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sqlite3_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/fmdb_model_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sqlite3_model_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sql_scope.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sql_condition.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/sql_model_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/join.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/fmdb_adapter.rb"
  app.ordered_build_files << "/Users/nicky/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/bundler/gems/MotionModel-9d7cebaf74be/motion/adapters/sql/relation.rb"
  app.ordered_build_files << "./app/modifiers/string.rb"
  app.ordered_build_files << "./app/models/fire.rb"
  app.ordered_build_files << "./app/app_delegate.rb"
  app.ordered_build_files << "./app/modules/assets.rb"
  app.ordered_build_files << "./app/modules/api.rb"
  app.ordered_build_files << "./app/modules/me.rb"
  app.ordered_build_files << "./app/modules/font.rb"
  app.ordered_build_files << "./app/modules/device.rb"
  app.ordered_build_files << "./app/modules/interests.rb"
  app.ordered_build_files << "./app/modules/color.rb"
  app.ordered_build_files << "./app/modules/eventModule.rb"
  app.ordered_build_files << "./app/modules/store.rb"
  app.ordered_build_files << "./app/models/EventTypes.rb"
  app.ordered_build_files << "./app/models/attendee.rb"
  app.ordered_build_files << "./app/models/keyval.rb"
  app.ordered_build_files << "./app/models/dispatch_item.rb"
  app.ordered_build_files << "./app/models/Notification.rb"
  app.ordered_build_files << "./app/models/community.rb"
  app.ordered_build_files << "./app/models/interest.rb"
  app.ordered_build_files << "./app/models/comment.rb"
  app.ordered_build_files << "./app/models/Chat.rb"
  app.ordered_build_files << "./app/models/event.rb"
  app.ordered_build_files << "./app/screens/atnstory_screen.rb"
  app.ordered_build_files << "./app/screens/attendee_screen.rb"
  app.ordered_build_files << "./app/screens/cart_screen.rb"
  app.ordered_build_files << "./app/screens/chat_detail_screen.rb"
  app.ordered_build_files << "./app/screens/chat_edit_screen.rb"
  app.ordered_build_files << "./app/screens/chat_screen.rb"
  app.ordered_build_files << "./app/screens/chats_screen.rb"
  app.ordered_build_files << "./app/screens/check_in_screen.rb"
  app.ordered_build_files << "./app/screens/community_screen.rb"
  app.ordered_build_files << "./app/screens/dispatch_screen.rb"
  app.ordered_build_files << "./app/screens/event_screen.rb"
  app.ordered_build_files << "./app/screens/event_types_screen.rb"
  app.ordered_build_files << "./app/screens/events_nav.rb"
  app.ordered_build_files << "./app/screens/events_screen.rb"
  app.ordered_build_files << "./app/screens/explore_screen.rb"
  app.ordered_build_files << "./app/screens/filters_screen.rb"
  app.ordered_build_files << "./app/screens/loading_screen.rb"
  app.ordered_build_files << "./app/screens/login_screen.rb"
  app.ordered_build_files << "./app/screens/more_screen.rb"
  app.ordered_build_files << "./app/screens/newchat_screen.rb"
  app.ordered_build_files << "./app/screens/notes_screen.rb"
  app.ordered_build_files << "./app/screens/notifications_screen.rb"
  app.ordered_build_files << "./app/screens/place_screen.rb"
  app.ordered_build_files << "./app/screens/post_screen.rb"
  app.ordered_build_files << "./app/screens/registration_screen.rb"
  app.ordered_build_files << "./app/screens/schedule_screen.rb"
  app.ordered_build_files << "./app/screens/walkthrough_screen.rb"
  app.ordered_build_files << "./app/screens/home_screen.rb"
  app.ordered_build_files << "./app/layouts/atnstory_layout.rb"
  app.ordered_build_files << "./app/layouts/attendee_layout.rb"
  app.ordered_build_files << "./app/layouts/cart_layout.rb"
  app.ordered_build_files << "./app/layouts/chat_detail_layout.rb"
  app.ordered_build_files << "./app/layouts/chat_edit_layout.rb"
  app.ordered_build_files << "./app/layouts/chat_layout.rb"
  app.ordered_build_files << "./app/layouts/chats_layout.rb"
  app.ordered_build_files << "./app/layouts/check_in_layout.rb"
  app.ordered_build_files << "./app/layouts/community_layout.rb"
  app.ordered_build_files << "./app/layouts/dispatch_layout.rb"
  app.ordered_build_files << "./app/layouts/event_layout.rb"
  app.ordered_build_files << "./app/layouts/event_types_layout.rb"
  app.ordered_build_files << "./app/layouts/events_layout.rb"
  app.ordered_build_files << "./app/layouts/explore_layout.rb"
  app.ordered_build_files << "./app/layouts/filters_layout.rb"
  app.ordered_build_files << "./app/layouts/home_layout.rb"
  app.ordered_build_files << "./app/layouts/loading_layout.rb"
  app.ordered_build_files << "./app/layouts/login_layout.rb"
  app.ordered_build_files << "./app/layouts/modal_layout.rb"
  app.ordered_build_files << "./app/layouts/more_layout.rb"
  app.ordered_build_files << "./app/layouts/newchat_layout.rb"
  app.ordered_build_files << "./app/layouts/notifications_layout.rb"
  app.ordered_build_files << "./app/layouts/notes_layout.rb"
  app.ordered_build_files << "./app/layouts/permission_layout.rb"
  app.ordered_build_files << "./app/layouts/place_layout.rb"
  app.ordered_build_files << "./app/layouts/popup_layout.rb"
  app.ordered_build_files << "./app/layouts/post_layout.rb"
  app.ordered_build_files << "./app/layouts/registration_layout.rb"
  app.ordered_build_files << "./app/layouts/schedule_layout.rb"
  app.ordered_build_files << "./app/layouts/walkthrough_layout.rb"
  app.ordered_build_files << "./app/layouts/walkthroughView_layout.rb"
  app.ordered_build_files << "./app/partials/AtnStoryCell.rb"
  app.ordered_build_files << "./app/partials/AttendeeButton.rb"
  app.ordered_build_files << "./app/partials/AttendeeSearchCell.rb"
  app.ordered_build_files << "./app/partials/AttendeeSearchNullLayout.rb"
  app.ordered_build_files << "./app/partials/AttendeeSearchResults.rb"
  app.ordered_build_files << "./app/partials/AttendeeSearchTitle.rb"
  app.ordered_build_files << "./app/partials/AttendeeSelectCell.rb"
  app.ordered_build_files << "./app/partials/AttendeeSelectResults.rb"
  app.ordered_build_files << "./app/partials/Avatar.rb"
  app.ordered_build_files << "./app/partials/ButtonList.rb"
  app.ordered_build_files << "./app/partials/ChatCell.rb"
  app.ordered_build_files << "./app/partials/ChatListing.rb"
  app.ordered_build_files << "./app/partials/ChatRowCell.rb"
  app.ordered_build_files << "./app/partials/ChatsListing.rb"
  app.ordered_build_files << "./app/partials/ChattersHorizontalList.rb"
  app.ordered_build_files << "./app/partials/CommunityCell.rb"
  app.ordered_build_files << "./app/partials/CommunityList.rb"
  app.ordered_build_files << "./app/partials/Dispatch.rb"
  app.ordered_build_files << "./app/partials/DispatchCell.rb"
  app.ordered_build_files << "./app/partials/DispatchContentCell.rb"
  app.ordered_build_files << "./app/partials/DispatchContentList.rb"
  app.ordered_build_files << "./app/partials/DividedNav.rb"
  app.ordered_build_files << "./app/partials/EventAttendees.rb"
  app.ordered_build_files << "./app/partials/EventCell.rb"
  app.ordered_build_files << "./app/partials/EventDaySelect.rb"
  app.ordered_build_files << "./app/partials/EventHostView.rb"
  app.ordered_build_files << "./app/partials/EventListing.rb"
  app.ordered_build_files << "./app/partials/EventSectionHeading.rb"
  app.ordered_build_files << "./app/partials/EventTypeCell.rb"
  app.ordered_build_files << "./app/partials/EventTypesListing.rb"
  app.ordered_build_files << "./app/partials/ExpirationPicker.rb"
  app.ordered_build_files << "./app/partials/HTMLTextView.rb"
  app.ordered_build_files << "./app/partials/NoteCell.rb"
  app.ordered_build_files << "./app/partials/NotesListing.rb"
  app.ordered_build_files << "./app/partials/NotificationCell.rb"
  app.ordered_build_files << "./app/partials/NotificationMarker.rb"
  app.ordered_build_files << "./app/partials/NotificationsListing.rb"
  app.ordered_build_files << "./app/partials/PlaceCell.rb"
  app.ordered_build_files << "./app/partials/PlaceListing.rb"
  app.ordered_build_files << "./app/partials/PlaceTypeSelect.rb"
  app.ordered_build_files << "./app/partials/Popup.rb"
  app.ordered_build_files << "./app/partials/PopupButton.rb"
  app.ordered_build_files << "./app/partials/PostOrderCell.rb"
  app.ordered_build_files << "./app/partials/PreOrderCell.rb"
  app.ordered_build_files << "./app/partials/ProgressDots.rb"
  app.ordered_build_files << "./app/partials/ScheduleCell.rb"
  app.ordered_build_files << "./app/partials/ScheduleDaySelect.rb"
  app.ordered_build_files << "./app/partials/ScheduleListing.rb"
  app.ordered_build_files << "./app/partials/ScrollView.rb"
  app.ordered_build_files << "./app/partials/UpdateCell.rb"
  app.ordered_build_files << "./app/partials/WDTextField.rb"
end

def define_icon_defaults!(app)
  # This is required as of iOS 11.0 (you must use asset catalogs to
  # define icons or your app will be rejected. More information in
  # located in the readme.

  app.info_plist['CFBundleIcons'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60']
    }
  }

  app.info_plist['CFBundleIcons~ipad'] = {
    'CFBundlePrimaryIcon' => {
      'CFBundleIconName' => 'AppIcon',
      'CFBundleIconFiles' => ['AppIcon60x60', 'AppIcon76x76']
    }
  }
end

Rake::Task["archive:distribution"].enhance do
  Rake::Task["fabric:dsym:device"].invoke
end

desc "Run simulator on iPhone"
task :iphone4 do
    exec 'bundle exec rake device_name="iPhone 4s"'
end

desc "Run simulator on iPhone"
task :iphone5 do
    exec 'bundle exec rake device_name="iPhone 5"'
end

desc "Run simulator on iPhone"
task :iphone6 do
    exec 'bundle exec rake device_name="iPhone 6"'
end

desc "Run simulator on iPhone 6 Plus"
task :iphone6p do
    exec 'bundle exec rake device_name="iPhone 6 Plus"'
end

desc "Run simulator in iPhone X"
task :x do
    exec 'bundle exec rake device_name="iPhone X"'
end

desc "Run simulator in iPad Retina"
task :retina do
    exec 'bundle exec rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air"
task :ipad do
    exec 'bundle exec rake device_name="iPad Air"'
end

def force_64bit_only!(app)
  # This is required as of iOS 11.0, 32 bit compilations will no
  # longer be allowed for submission to the App Store.

  app.archs['iPhoneOS'] = ['arm64']
  app.info_plist['UIRequiredDeviceCapabilities'] = ['arm64']
end