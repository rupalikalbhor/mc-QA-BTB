require "spec/spec_helper"
require 'spec/support/data_helper'
require 'spec/support/query_helper'

def go_to_BTB_page
  visit '/'
end

def go_to_BTB_page1
  case $device_name
    when :phone
      visit 'http://btb-ecomm.demo.modcloth.com/be-the-buyer/voting-in-progress?device_type=phone'
    when :tablet
      visit 'http://btb-ecomm.demo.modcloth.com/be-the-buyer/voting-in-progress?device_type=tablet'
    else
      visit 'http://btb-ecomm.demo.modcloth.com/be-the-buyer'
  end
end

def wait_for_script
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

def sign_in()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-sign-in']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  visit '/'
  wait_for_script
  #should_be_signed_in_as_user()    #Need to uncomment this once issue gets fixed. THIS IS TEMPORARY
end

def should_be_signed_in_as_user()
  name = $first_name
  short_name = get_short_name(name)
  should_be_signed_in_with_name(short_name)
end

def get_short_name(name)
  if (name == '')
    email = $email
    name = email.match(/([\S]+)@/)[1]
  elsif (name.length > 15)
    name = "#{name[0..14]}..."
  end
  name
end

def should_be_signed_in_with_name(name)
  within('#mc-header') do
    page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(name)
  end
end

def sign_out()
  page.find(:xpath, "//div[@class = 'name-and-arrow']/div").click
  page.find(:xpath, "//a[@class = 'sign-out']").click
  page.should have_xpath("//div[@id = 'mc-header-join-or-sign-in']")
end

def generate_new_email
  number = Time.now.to_i.to_s
  "new-user#{number}@modcloth.com"
end

def join()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

#---------------------------------------------------------------------
def join_desktop()
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

def sign_in_desktop()
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-sign-in']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  visit '/'
  wait_for_script

  name = $first_name
  short_name = get_short_name(name)
  within('#mc-header') do
    page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(short_name)
  end
end

#-----------------------
def join_tablet()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

def sign_in_tablet()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-sign-in']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  visit '/'
  wait_for_script

  name = $first_name
  short_name = get_short_name(name)
  within('#mc-header') do
    page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(short_name)
  end
  #should_be_signed_in_as_user()    #Need to uncomment this once issue gets fixed. THIS IS TEMPORARY
end

#---------------------------------------

def join_phone()

end

def sign_in_phone()

end

#-----------------------------------------

def sign_out_desktop()

end

def sign_out_tablet()

end

def sign_out_phone()

end