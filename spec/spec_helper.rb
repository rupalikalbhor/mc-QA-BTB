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
end

