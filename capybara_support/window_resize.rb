def set_window_size
  case $device_name
    when :desktop
      page.driver.browser.manage().window().maximize()
    when :iphone
      page.driver.browser.manage().window().resize_to(640, 960)
    when :ipad
      page.driver.browser.manage().window().resize_to(1024, 768)
    else
      puts 'Invalid device name..Running on default device DESKTOP !!!!'
  end
end