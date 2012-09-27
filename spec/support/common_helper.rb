require "spec/spec_helper"
require 'spec/support/data_helper'
require 'spec/support/query_helper'

def go_to_BTB_page
  case $device_name
    when :phone
      visit 'http://btb.demo.modcloth.com/be-the-buyer/voting-in-progress?device_type=phone'
      #visit 'http://btb.demo.modcloth.com/be-the-buyer'

      #visit 'http://10.3.30.207:3003/be-the-buyer/voting-in-progress?device_type=phone'
      #visit 'http://10.3.30.207:3003/be-the-buyer'
    when :tablet
      visit 'http://btb.demo.modcloth.com/be-the-buyer/voting-in-progress?device_type=tablet'
    else
      visit 'http://btb.demo.modcloth.com/be-the-buyer'
  end
end

def wait_for_script
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

def should_be_signed_in_as_user(name, email)
  name = get_short_name(name, email)
  return name
end

def get_short_name(name, email)
  if (name == '')
    name = email.match(/([\S]+)@/)[1]
    if (name.length > 15)
      name = "#{name[0..14]}..."
    else
      name
    end
  elsif (name.length > 15)
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

def join_phone()
  within ('#mc-phone-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']").click
    wait_for_script
  end
  email_address = generate_new_email
  page.find(:xpath, "//a[@href = '/customers/accounts/new']").click
  wait_for_script
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
  go_to_BTB_page  #NEED to uncomment this one once issue gets fixed.
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
  name = should_be_signed_in_as_user($first_name, $email)
  page.find(:xpath, "//div[@class='name-and-arrow']").text.should eq('Hi, '+name)
end

def sign_in_phone()
  within ('#mc-phone-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  wait_for_script
  name = should_be_signed_in_as_user($first_name, $email)
  page.find(:xpath, "//div[@id='mc-phone-header-welcome']/span").text.should eq('Hello')
  page.find(:xpath, "//div[@id='mc-phone-header-welcome']/a").text.should eq(name)
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
  page.find(:xpath, "//a[@class = 'member-dropdown']").click
  page.find(:xpath, "//a[@class = 'button button-medium']").click
  wait_for_script
  page.should have_xpath("//a[@id = 'mc-phone-header-join']")
end

def get_available_product()
  product_data = get_product_data[$environment.to_s]
  product_name = product_data['name']
  return product_name
end

def add_product_into_shopping_bag
  go_to_BTB_page
  available_product = get_available_product
  fill_in 'mc-header-keyword', :with => available_product
  click_button('GO')
  wait_for_script
  page.find(:xpath, "//p[@class = 'title']").click
  wait_for_script
  page.find(:xpath, "//button[@id = 'variant-button']").click
  page.should have_content(available_product)
end

def remove_product_from_shopping_bag
  go_to_BTB_page
  page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
  wait_for_script
  page.find(:xpath, "//a[@class = 'remove_item_link remove_from_cart']").click
  wait_for_script
  page.should have_content('Your Shopping Bag is Empty')
end