#SPEC_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(SPEC_ROOT)
require 'rspec'
require 'capybara/dsl'
require 'capybara_support/configuration'
require 'screenshot_support/screenshot_helper'


RSpec.configure do |config|

  config.before(:all) do
    CapybaraSupport::Configuration.reset_capybara
    puts "capybara reset"
  end
  config.include Capybara::DSL
  CapybaraSupport::Configuration.configure_environment
  ScreenshotSupport::ScreenshotHelper.install_formatter(config)

  #CapybaraSupport::WindowResize.testing

  #DESKTOP_SCREENSIZE = {:width => 1280, :height => 1024}
  #MOBILE_SCREENSIZE = {:width => 320, :height => 480}
  #IPAD_SCREENSIZE = {:width => 1024, :height => 768}

  #def self.testing
  #  if example.metadata[:mobile]
  #    CapybaraSupport::Configuration.resize_browser_window($screensize)
  #  else
  #    CapybaraSupport::Configuration.resize_browser_window(DESKTOP_SCREENSIZE)
  #  end
  #end


end


