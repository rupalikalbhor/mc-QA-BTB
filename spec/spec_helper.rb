#SPEC_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(SPEC_ROOT)
require 'rspec'
require 'capybara/dsl'
require 'capybara_support/configuration'
require 'screenshot_support/screenshot_helper'
require 'support/common_helper'
require 'spec/support/query_helper'

i = 0
RSpec.configure do |config|
  config.before(:all) do
    CapybaraSupport::Configuration.reset_capybara

    #This function will execute register_user only onces
    #if (i == 0)
    #  email = register_user() #Write register users value into jason file
    #  puts "Following user registered successfully: #{email}"
    #  i = i + 1
    #end

  end
  config.include Capybara::DSL
  CapybaraSupport::Configuration.configure_environment
  ScreenshotSupport::ScreenshotHelper.install_formatter(config)
end


