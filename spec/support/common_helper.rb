require "spec/spec_helper"
require 'spec/support/data_helper'
require 'spec/support/query_helper'

#def go_to_BTB_page
#  visit '/'
#end

def go_to_BTB_page
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

#def sign_in()
#  within ('#mc-header-welcome') do
#    page.find(:xpath, "//div[@id='mc-header-sign-in']").click
#    wait_for_script
#  end
#  within ('#login-form') do
#    fill_in 'email', :with => $email
#    fill_in 'sign_in_password', :with => $password
#    click_button('Sign In')
#  end
#  visit '/'
#  wait_for_script
#  #should_be_signed_in_as_user()    #Need to uncomment this once issue gets fixed. THIS IS TEMPORARY
#end

def should_be_signed_in_as_user(name, email)
  #name = $first_name
  name = get_short_name(name, email)
  return name
  #should_be_signed_in_with_name(short_name)
end

def get_short_name(name, email)
  if (name == '')
    name = email.match(/([\S]+)@/)[1]
    if(name.length > 15)
      name = "#{name[0..14]}..."
    else
      name
    end
  elsif(name.length > 15)
    name = "#{name[0..14]}..."
  end
  return name
end

def should_be_signed_in_as_user1()
  name = $first_name
  short_name = get_short_name1(name)
  should_be_signed_in_with_name(short_name)
end

def get_short_name1(name)
  if (name == '')
    email = $email
    name = email.match(/([\S]+)@/)[1]
  elsif (name.length > 15)
    name = "#{name[0..14]}..."
  end
  name
end

def should_be_signed_in_with_name1(name)
  within('#mc-header') do
    page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(name)
  end
end

def generate_new_email
  number = Time.now.to_i.to_s
  "new-user#{number}@modcloth.com"
end

#---------------------------------------
def join()
  case $device_name
    when :phone
      join_phone()
    when :tablet
      join_tablet()
    else
      join_desktop()
  end
end

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
  name = should_be_signed_in_as_user('', email_address)
  page.find(:xpath, "//div[@id='mc-header-hello']/span").text.should eq('Hello,')
  page.find(:xpath, "//a[@id='mc-header-welcome-name']").text.should eq(name)
end

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

def join_phone() #pending
  within ('#mc-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']").click
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

def sign_in()
  case $device_name
    when :phone
      sign_in_phone()
    when :tablet
      sign_in_tablet()
    else
      sign_in_desktop()
  end
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
  wait_for_script
  name = should_be_signed_in_as_user($first_name, $email)
  page.find(:xpath, "//div[@id='mc-header-hello']/span").text.should eq('Hello,')
  page.find(:xpath, "//a[@id='mc-header-welcome-name']").text.should eq(name)
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
  wait_for_script

  #name = $first_name              #Need to uncomment this part once issue gets fixed
  #short_name = get_short_name(name)
  #within('#mc-header') do
  #  page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(short_name)
  #end
  #should_be_signed_in_as_user()    #Need to uncomment this once issue gets fixed. THIS IS TEMPORARY
end

def sign_out()
  case $device_name
    when :phone
      sign_out_phone()
    when :tablet
      sign_out_tablet()
    else
      sign_out_desktop()
  end
end

def sign_out_desktop()
  page.find(:xpath, "//a[@id = 'mc-header-sign-out']").click
  wait_for_script
  within('#mc-header-personalization') do
    page.should have_link('Sign In')
  end
end

def sign_out_tablet()
  page.find(:xpath, "//div[@class = 'name-and-arrow']/div").click
  page.find(:xpath, "//a[@class = 'sign-out']").click
  page.should have_xpath("//div[@id = 'mc-header-join-or-sign-in']")
end

def sign_out_phone()

end