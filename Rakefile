# -*- coding: utf-8 -*-


### CRASH SYMBOLICATING
# ./symbolicatecrash -o /nky/wds-ios/crashes/l3.3.txt /nky/wds-ios/crashes/logs3/4.crash
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
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
  require 'ProMotion'
  require 'motion-cocoapods'
  require 'map-kit-wrapper'
  require 'motion-markdown-it'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WDS App'
  app.frameworks += ["QuartzCore", "CoreImage"]
  app.identifier = 'com.worlddominationsummit.wdsios'


  ## UPDATE APP DELEGATE VERSION
  app.version = '17.4'
  app.short_version = '2.2.5'
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
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.info_plist['ITSAppUsesNonExemptEncryption'] = false
  app.libs += ['/usr/lib/libsqlite3.dylib']
  app.vendor_project 'vendor/FMDB', :static
  app.vendor_project 'vendor/MMMarkdown/Source', :static
  app.interface_orientations = [:portrait]
  app.icons = ['Icon.png', 'Icon@2x.png', 'Icon@3x.png']
  app.deployment_target = "8.0"
  app.fonts = ['Karla-Regular.ttf', 'Karla-BoldItalic.ttf', 'Karla-Italic.ttf', 'Karla-Bold.ttf', 'Vitesse-Bold.otf', 'Vitesse-Book.otf', 'Vitesse-Light.otf', 'Vitesse-Medium.otf', 'ionicons.ttf']
  app.pods do
    pod 'SDWebImage', '~>3.7'
    pod 'SZTextView'
    pod 'ionicons'
    pod 'OpenInChrome'
    pod 'SORelativeDateTransformer'
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

desc "Run simulator in iPad Retina"
task :retina do
    exec 'bundle exec rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air"
task :ipad do
    exec 'bundle exec rake device_name="iPad Air"'
end