require 'screenshot_support/screenshot_formatter'

module ScreenshotSupport
class ScreenshotHelper
  def self.install_formatter(config)
    documentation_formatter = config.send(:built_in_formatter, :documentation).new(config.output)
    custom_formatter = ScreenshotFormatter.new(StringIO.new)
    config.instance_variable_set(:@reporter, RSpec::Core::Reporter.new(documentation_formatter, custom_formatter))
  end
end
end