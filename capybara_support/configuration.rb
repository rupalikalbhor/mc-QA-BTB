require 'capybara'
require 'selenium/webdriver'

module CapybaraSupport
  class Configuration
    @default_env = :stage
    @default_browser = :firefox

    def self.configure_environment
      @environment = ENV.fetch('ENV_NAME', @default_env).to_sym
      @browser_name = ENV.fetch('BROWSER_NAME', @default_browser).to_sym

      Capybara.app_host = self.get_environment_url
      #Capybara.default_driver = ENV.fetch('DEFAULT_DRIVER','selenium').to_sym

      Capybara.default_driver = :selenium
      puts "Set the Capybara default driver to #{Capybara.default_driver}"
      puts "Tests are running on environment: #{@environment}"

      self.get_browser

    end

    def self.reset_capybara
      Capybara.reset!
      Capybara.current_driver = Capybara.default_driver
      Capybara.javascript_driver = Capybara.default_driver #default driver when you using @javascript tag

      #Capybara.page.driver.header('user-agent',CapybaraSupport::WebkitDrivers.user_agent_for(Capybara.default_driver))

      Capybara.default_wait_time = 10 #When testing AJAX, we can set a default wait time
      Capybara.server_boot_timeout = 30
      Capybara.default_selector = :css #:xpath #default selector , you can change to :css
      Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
    end

    def self.register_drivers
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, :browser => self.get_browser)
      end
    end

    def self.get_environment_url
      case @environment
        when :demo
          'http://social-ecomm.demo.modcloth.com'
        when :stage
          'http://www.stage.modcloth.com'
        when :preview
          'http://preview.prod.modcloth.com'
        when :production
          'http://www.modcloth.com'
        else
          puts 'Invalid environment name..'
      end
    end

    def self.get_browser
      puts "browser name is: #{@browser_name}"
      case @browser_name
        when :firefox
          puts "Running tests using Firefox browser"
          profile = Selenium::WebDriver::Firefox::Profile.new
          profile.assume_untrusted_certificate_issuer = false
          puts "Registering selenium driver with profile=#{profile.inspect}"
          Capybara.register_driver :selenium do |app|
            Capybara::Selenium::Driver.new(app, :profile => profile)
          end

        when :chrome
          puts "Running tests using Chrome browser"
          Capybara.register_driver :selenium_chrome do |app|
            Capybara::Selenium::Driver.new(app, :browser => :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate])
          end
      end
    end
  end
end


