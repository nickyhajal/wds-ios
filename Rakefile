# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
  require 'sugarcube'
  require 'sugarcube-timer'
  require 'sugarcube-nsdate'
  require 'sugarcube-color'
  require 'bubble-wrap'
  require 'motion-kit'
  require 'motion_model'
  require 'motion_model/array'
  require 'motion_model/sql'
  require 'bubble-wrap-http'
  require 'ProMotion'
  require 'motion-cocoapods'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WDS App'
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.libs += ['/usr/lib/libsqlite3.dylib']
  app.vendor_project 'vendor/FMDB', :static
  app.fonts = ['Karla-Regular.ttf', 'Karla-Italic.ttf', 'Karla-Bold.ttf', 'Vitesse-Bold.otf', 'Vitesse-Book.otf', 'Vitesse-Light.otf', 'Vitesse-Medium.otf']
  app.pods do
    pod 'SDWebImage', '~>3.6'
  end
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

desc "Run simulator in iPad Retina" 
task :retina do
    exec 'bundle exec rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air" 
task :ipad do
    exec 'bundle exec rake device_name="iPad Air"'
end