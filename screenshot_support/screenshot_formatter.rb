require 'rspec/core/formatters/progress_formatter'

class ScreenshotFormatter < RSpec::Core::Formatters::ProgressFormatter
  def example_failed(example)
    super(example)
    Capybara.page.driver.browser.save_screenshot("./tmp/screenshots/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
  end
end



