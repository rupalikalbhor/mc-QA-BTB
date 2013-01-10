require 'capybara'
require 'selenium/webdriver'
require 'support/data_helper'
require 'selenium-webdriver'
require 'webdriver-user-agent'


module CapybaraSupport
  class Configuration
    @default_env = :demo
    @default_browser = :firefox
    @default_device = :desktop
    $environment #Declaring global variable

    def self.reset_capybara
      Capybara.reset!
      Capybara.javascript_driver = Capybara.default_driver #default driver when you using @javascript tag
      Capybara.default_wait_time = 30 #When testing AJAX, we can set a default wait time
      Capybara.server_boot_timeout = 30
      Capybara.default_selector = :css #:xpath #default selector , you can change to :css
      Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
    end

    def self.configure_environment
      $environment = ENV.fetch('ENV_NAME', @default_env).to_sym
      @browser_name = ENV.fetch('BROWSER_NAME', @default_browser).to_sym
      $device_name = ENV.fetch('DEVICE_NAME', @default_device).to_sym

      Capybara.app_host = self.get_environment_url
      Capybara.default_driver = ENV.fetch('DEFAULT_DRIVER', self.set_default_driver).to_sym
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
          'http://btb-ecomm.demo.modcloth.com'
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

    def self.user_info
      user_data = get_regular_user_data
      $email = user_data['email']
      $password = user_data['password']
    end

    def self.set_default_driver
      case $device_name
        when :desktop
          'selenium'
        when :phone
          :iphone
        when :tablet
          :ipad
      end
    end

    def self.get_user_agent(profile)
      case $device_name
        when :desktop
          ""
        when :phone #iPhone with ios = 5.0
                    #"iPhone"

          profile['general.useragent.override'] = "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"
        when :tablet #iPad with ios = 5.0
          profile['general.useragent.override'] = "Mozilla/5.0 (iPad; CPU OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"
      end
    end

    def self.get_browser
      case @browser_name
        when :firefox
          puts "Running tests using FIREFOX browser"
          Capybara.register_driver Capybara.default_driver do |app|
            profile = Selenium::WebDriver::Firefox::Profile.new
            get_user_agent(profile)
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
        when :phone
          @browser_size = {:width => 431, :height => 960}
        when :tablet
          @browser_size = {:width => 1024, :height => 768}
        else
          puts 'Invalid device name..Running on default device DESKTOP !!!!'
      end
    end

    def self.resize_browser_window()
      self.set_browser_size
      case $device_name
        when :desktop
          Capybara.current_session.driver.browser.manage.window.maximize
        when :phone
          Capybara.current_session.driver.browser.manage.window.resize_to(@browser_size[:width], @browser_size[:height])
        when :tablet
          Capybara.current_session.driver.browser.manage.window.resize_to(@browser_size[:width], @browser_size[:height])
        else
          puts 'Invalid device name..Running on default device DESKTOP !!!!'
      end
    end
  end
end