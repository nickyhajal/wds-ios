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
  require 'ProMotion'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WDS App'
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.fonts = ['Karla-Regular.ttf', 'Karla-Italic.ttf', 'Karla-Bold.ttf', 'Vitesse-Bold.otf', 'Vitesse-Book.otf', 'Vitesse-Light.otf', 'Vitesse-Medium.otf']
end
