require 'capybara'
require 'selenium/webdriver'
require 'support/data_helper'

module CapybaraSupport
  class Configuration
    @default_env = :demo
    @default_browser = :firefox
    @default_device = :desktop
    $environment #Declaring global variable

    def self.reset_capybara
      Capybara.reset!
      Capybara.current_driver = Capybara.default_driver
      Capybara.javascript_driver = Capybara.default_driver #default driver when you using @javascript tag
      Capybara.default_wait_time = 10 #When testing AJAX, we can set a default wait time
      Capybara.server_boot_timeout = 30
      Capybara.default_selector = :css #:xpath #default selector , you can change to :css
      Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
    end

    def self.configure_environment
      $environment = ENV.fetch('ENV_NAME', @default_env).to_sym
      @browser_name = ENV.fetch('BROWSER_NAME', @default_browser).to_sym
      $device_name = ENV.fetch('DEVICE_NAME', @default_device).to_sym

      Capybara.app_host = self.get_environment_url
      Capybara.default_driver = ENV.fetch('DEFAULT_DRIVER', 'selenium').to_sym
      Capybara.default_driver = :selenium
      puts "Set the Capybara default driver to #{Capybara.default_driver}"
      puts "Tests are running on environment: #{$environment}"
      puts "Window size is set for: #{$device_name}"

      #self.set_user #Set user email for the environment
      self.user_info
      self.get_browser
      self.resize_browser_window()
    end

    def self.get_environment_url
      case $environment
        when :demo
          #'http://BTB-demo.modcloth.com'
          'http://btb-ecomm.demo.modcloth.com/be-the-buyer'
        when :stage
          'http://BTB.stage.modcloth.com'
        when :preview
          'http://preview.prod.modcloth.com'
        when :production
          'http://www.modcloth.com'
        else
          puts 'Invalid environment name..Running on default environment STAGE !!!!'
      end
    end

    def self.set_user
      case $environment
        when :demo
          $user = 'demo_sign_in'
        when :stage
          $user = 'stage_sign_in'
        when :preview
          $user = 'preview_sign_in'
        when :production
          $user = 'prod_sign_in'
        else
          puts 'Invalid environment name..Running on default environment STAGE !!!!'
      end
    end

    def self.user_info
      self.set_user
      user_data = get_user_data[$user]
      $email = user_data['email']
      $password = user_data['password']
      $first_name = user_data['first-name']
      $last_name = user_data['last_name']
    end

    def self.get_browser
      case @browser_name
        when :firefox
          puts "Running tests using FIREFOX browser"
          profile = Selenium::WebDriver::Firefox::Profile.new
          profile.assume_untrusted_certificate_issuer = false
          Capybara.register_driver :selenium do |app|
            Capybara::Selenium::Driver.new(app, :profile => profile)
          end

        when :chrome
          puts "Running tests using CHROME browser"
          Capybara.register_driver :selenium do |app|
            Capybara::Selenium::Driver.new(app, :browser => :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate])
          end
        else
          puts 'Invalid browser name..Running on default browser FIREFOX !!!!'
      end
    end

    def self.set_browser_size
      case $device_name
        when :desktop
          @browser_size = {:width => 1024, :height => 1024}
        #when :phone_portrait
        when :phone
          @browser_size = {:width => 320, :height => 960}
        #when :phone_landscape
        #  @browser_size = {:width => 480, :height => 960}
        #when :tablet_portrait
        when :tablet
          @browser_size = {:width => 768, :height => 768}
        #when :tablet_landscape
        #  @browser_size = {:width => 1024, :height => 768}
        else
          puts 'Invalid device name..Running on default device DESKTOP !!!!'
      end
    end

    def self.resize_browser_window()
      self.set_browser_size
      Capybara.current_session.driver.browser.manage.window.resize_to(@browser_size[:width], @browser_size[:height])
    end
  end
end