# encoding: utf-8
require "spec/spec_helper"
#require 'spec/support/data_helper'
#require 'spec/support/query_helper'

def go_to_BTB_page
  visit '/'+'be-the-buyer/voting-in-progress'
  wait_for_script
  page.has_xpath?("//div[@id = 'btb-logo']", :visible => true)
end

def register_user()
  go_to_BTB_page
  wait_for_script
  email_address = join()
  wait_for_script
  tempHash = {
      "email" => email_address,
      "password" => "testing"}
  write_json_data(RegularUserData, tempHash)

  user_data = get_regular_user_data #set email & password constant values
  $email = user_data['email']
  $password = user_data['password']
  wait_for_script
  page.driver.browser.navigate.refresh
  sign_out
  return email_address
end

def wait_for_script(wait_time = Capybara.default_wait_time)
  wait_until(wait_time) do
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

def generate_new_email
  number = Time.now.to_i.to_s
  "new-user#{number}@modcloth.com"
end

#---------------------------------------
def join()
  email_address = generate_new_email
  case $device_name
    when :phone
      join_phone(email_address)
    when :tablet
      join_tablet(email_address)
    else
      join_desktop(email_address)
  end
end

def join_desktop(email_address)
  page.has_xpath?("//a[@href = '/join?gate=join']", :visible => true)
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-join']", :visible => true).click
    wait_for_script
    #wait_until (Capybara.default_wait_time){page.find(:xpath,"//input[@id = 'account_email']").visible? == true}
  end
  page.has_xpath?("//input[@id = 'account_email']", :visible => true)
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  name = should_be_signed_in_as_user('', email_address)

  page.has_xpath?("//div[@id='mc-header-hello']/span", :visible => true)
  page.find(:xpath, "//div[@id='mc-header-hello']/span", :visible => true).text == 'Hello,'
  page.find(:xpath, "//a[@id='mc-header-welcome-name']", :visible => true).text == name
  return email_address
end

def join_tablet(email_address)
  page.find(:xpath, "//a[@id='mc-header-join']", :visible => true).click
  wait_for_script

  page.find(:xpath, "//input[@id = 'account_email']", :visible => true)
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  name = should_be_signed_in_as_user('', email_address)
  page.has_xpath?("//div[@id='mc-header-hello']/span", :visible => true)

  page.find(:xpath, "//div[@id='mc-header-hello']/span", :visible => true).text.should eq('Hello,')
  page.find(:xpath, "//div[@id='mc-header-hello']/a", :visible => true).text.should eq(name)
  return email_address
end

def join_phone(email_address)
  page.find(:xpath, "//a[@id = 'mc-phone-header-join']", :visible => true)
  within ('#mc-phone-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']", :visible => true).click
    wait_for_script
  end
  page.has_xpath?("//input[@id = 'account_email']", :visible => true)
  within ('#signup-form') do
    fill_in 'account_email', :with => email_address
    fill_in 'account_password', :with => $password
    fill_in 'account-password-confirmation', :with => $password
    click_button('Join')
  end
  wait_until {
    page.has_xpath?("//div[@id='mc-phone-header-welcome']/span", :visible => true)
    name = should_be_signed_in_as_user('', email_address)
    page.find(:xpath, "//div[@id='mc-phone-header-welcome']/span", :visible => true).text.should eq('Hello')
    page.find(:xpath, "//div[@id='mc-phone-header-welcome']/a", :visible => true).text.should eq(name)
  }
  return email_address
end

def click_sign_in_link
  case $device_name
    when :phone
      click_phone_sign_in_link
    when :tablet
      click_tablet_sign_in_link
    else
      click_desktop_sign_in_link
  end
end

def click_phone_sign_in_link
  within ('#mc-phone-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']", :visible => true).click
    wait_for_script
  end
end

def click_tablet_sign_in_link
  page.find(:xpath, "//a[@id='mc-header-sign-in']", :visible => true).click
  wait_for_script
end

def click_desktop_sign_in_link
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-sign-in']", :visible => true).click
    wait_for_script
  end
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
  page.find(:xpath, "//input[@id = 'email']", :visible => true)
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
    wait_for_script
  end
  name = should_be_signed_in_as_user('', $email)
  page.has_xpath?("//div[@id='mc-header-hello']/span", :visible => true)
  page.find(:xpath, "//div[@id='mc-header-hello']/span").text.should eq('Hello,')
  page.find(:xpath, "//a[@id='mc-header-welcome-name']").text.should eq(name)
end

def sign_in_tablet
  page.find(:xpath, "//input[@id = 'email']", :visible => true)
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
    wait_for_script
  end
  name = should_be_signed_in_as_user('', $email)
  page.has_xpath?("//div[@id='mc-header-hello']/span", :visible => true)
  page.find(:xpath, "//div[@id='mc-header-hello']/span").text.should eq('Hello,')
  page.find(:xpath, "//div[@id='mc-header-hello']/a").text.should eq(name)
end

def sign_in_phone
  page.find(:xpath, "//input[@id = 'email']", :visible => true)
  within ('#signin-form') do
    fill_in 'email', :with => $email
    fill_in 'password', :with => $password
    click_button('Sign In')
    wait_for_script
  end
  name = should_be_signed_in_as_user('', $email)
  page.has_xpath?("//div[@id='mc-phone-header-welcome']/span", :visible => true)
  page.find(:xpath, "//div[@id='mc-phone-header-welcome']/span").text.should eq('Hello')
  page.find(:xpath, "//div[@id='mc-phone-header-welcome']/a").text.should eq(name)
end

def sign_in_with_facebook()
  case $device_name
    when :phone
      sign_in_facebook_phone()
    when :tablet
      sign_in_facebook_tablet()
    else
      sign_in_facebook_desktop()
  end
end

def sign_in_facebook_desktop
  page.find(:xpath, "//a[@class = 'facebook-connect-button']", :visible => true).click
  #user_data = get_user_data['facebook']
  user_data = get_facebook_user_data

  email = user_data['email']
  password = user_data['password']
  name = user_data['name']

  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.find(:xpath, "//form[@id = 'login_form']", :visible => true)
    within ('#login_form') do
      fill_in 'email', :with => email
      fill_in 'pass', :with => password
      click_button('Log In')
    end
  end

  go_to_BTB_page
  page.find(:xpath, "//div[@id='mc-header-hello']/span", :visible => true).text.should eq('Hello,')
  page.find(:xpath, "//a[@id='mc-header-welcome-name']", :visible => true).text.should eq(name)
end

def sign_in_facebook_tablet
  page.find(:xpath, "//a[@class = 'facebook-connect-button']", :visible => true).click
  user_data = get_facebook_user_data
  email = user_data['email']
  password = user_data['password']
  name = user_data['name']

  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.find(:xpath, "//form[@id = 'login_form']", :visible => true)
    within ('#login_form') do
      fill_in 'email', :with => email
      fill_in 'pass', :with => password
      click_button('Log In')
    end
  end
  go_to_BTB_page
  page.find(:xpath, "//div[@id='mc-header-hello']/span", :visible => true).text.should eq('Hello,')
  page.find(:xpath, "//div[@id='mc-header-hello']/a", :visible => true).text.should eq(name)
end

def sign_in_facebook_phone
  page.find(:xpath, "//a[@class = 'facebook-connect-button']", :visible => true).click
  user_data = get_facebook_user_data
  email = user_data['email']
  password = user_data['password']
  name = user_data['name']

  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.find(:xpath, "//form[@id = 'login_form']", :visible => true)
    within ('#login_form') do
      fill_in 'email', :with => email
      fill_in 'pass', :with => password
      click_button('Log In')
    end
  end

  go_to_BTB_page
  wait_until {
    page.has_xpath?("//div[@id='mc-phone-header-welcome']/span", :visible => true)
    page.find(:xpath, "//div[@id='mc-phone-header-welcome']/span", :visible => true).text.should eq('Hello')
    page.find(:xpath, "//div[@id='mc-phone-header-welcome']/a", :visible => true).text.should eq(name)
  }
  #end
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
  wait_until {
    page.find(:xpath, "//a[@id = 'mc-header-sign-out']").visible? == true
  }
  page.find(:xpath, "//a[@id = 'mc-header-sign-out']", :visible => true).click
  wait_until {
    page.find(:xpath, "//a[@id = 'mc-header-sign-in']").visible? == true
  }
end

def sign_out_tablet()
  page.find(:xpath, "//a[@id = 'mc-header-sign-out']", :visible => true).click
  wait_until {
    page.find(:xpath, "//a[@id = 'mc-header-sign-in']").visible? == true
  }
end

def sign_out_phone()
  page.has_xpath?("//div[@id = 'mc-phone-header-welcome']/a[@class = 'member-dropdown']", :visible => true)
  page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a[@class = 'member-dropdown']", :visible => true).click
  page.find(:xpath, "//a[@class = 'button button-medium']", :visible => true).click
  page.has_xpath?("//a[@id = 'mc-phone-header-join']", :visible => true)
  page.should have_xpath("//a[@id = 'mc-phone-header-join']", :text => "Join or Sign In")
  page.should have_xpath("//div[@id = 'btb-logo']")
end

def remove_product_from_shopping_bag
  go_to_BTB_page
  page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']", :visible => true).click
  wait_for_script
  page.find(:xpath, "//a[@class = 'remove_item_link remove_from_cart']", :visible => true).click
  wait_for_script
  page.should have_content('Your Shopping Bag is Empty')
end

def get_voting_date_time(expected_voting_time)
  strlength = expected_voting_time.length
  days = expected_voting_time[0, 1]+"d"+" "

  if (strlength > 8)
    hours = expected_voting_time[strlength - 8, 2]
    if (hours != "00")
      hours_first_number = hours[0, 1]

      if (hours_first_number == '0')
        hours = hours[1, 1]+"h"
      else

        hours = hours+"h"
      end
      voting_days = days + hours

    else
      voting_days = days
    end
  else
    hours = expected_voting_time[0, 2]
    if (hours != "00")
      hours_first_number = hours[0, 1]

      if (hours_first_number == '0')
        hours = hours[1, 1]+"h"
      else
        hours = hours+"h"
      end
      voting_days = hours
    else
      minutes = expected_voting_time[3, 2]
      minutes_first_number = minutes[0, 1]
      if (minutes_first_number == '0')
        minutes = minutes[1, 1]+"m"
      else
        minutes = minutes+"m"
      end
      voting_days = minutes
    end
  end
  return voting_days
end

def go_to_voting_in_progress_page
  go_to_BTB_page
  case $device_name
    when :phone
      page.find(:xpath, "//div[@id='menu-toggle']", :visible => true).click
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]", :visible => true).click
      page.find(:xpath, "//div[@id = 'menu-toggle']", :visible => true).text.should == "Voting In Progress"
    else
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]", :visible => true).click
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']", :visible => true).text.should == 'Voting In Progress'
  end
  wait_for_script
end

def go_to_awaiting_results_page
  go_to_BTB_page
  wait_for_script
  case $device_name
    when :phone
      page.find(:xpath, "//div[@id='menu-toggle']", :visible => true).click
      page.find(:xpath, "//a[@href='/be-the-buyer/awaiting-results']/li/div[contains(text(),'Awaiting Results')]", :visible => true).click
      wait_until {
        page.find(:xpath, "//div[@id = 'menu-toggle']", :visible => true).text.should == "Awaiting Results"
      }
      wait_for_script
    else
      page.find(:xpath, "//a[@href='/be-the-buyer/awaiting-results']/li/div[contains(text(),'Awaiting Results')]", :visible => true).click
      wait_until {
        page.find(:xpath, "//h2[@class='page-title awaiting-results']", :visible => true).text.should == 'Awaiting Results'
      }
  end
  wait_for_script
end

def go_to_SDP_page(sample_product_id)
  page.find(:xpath, "//div[@data-product-id="+sample_product_id+"]/div[@class = 'photo']/a", :visible => true).click
  wait_until {
    page.should have_xpath("//div[@class='sdp']")
  }
end

def go_to_available_now_page
  go_to_BTB_page
  wait_for_script
  case $device_name
    when :phone
      page.find(:xpath, "//div[@id='menu-toggle']", :visible => true).click
      page.find(:xpath, "//a[@href='/be-the-buyer/available-now']/li/div[contains(text(),'Available Now')]", :visible => true).click
    else
      page.find(:xpath, "//a[@href = '/be-the-buyer/available-now']", :visible => true).click
      wait_for_script
      if ($device_name == :desktop)
        page.find(:xpath, "//div[@id ='page_title']/h1", :visible => true).text.should == "Be the Buyer » Available Now"
      else
        page.find(:xpath, "//div[@class = 'category-sort']/h1", :visible => true).text.should == "Be the Buyer » Available Now"
      end
  end
  wait_for_script
end

def go_to_in_production_page
  go_to_BTB_page
  wait_for_script
  case $device_name
    when :phone
      page.find(:xpath, "//div[@id='menu-toggle']", :visible => true).click
      page.find(:xpath, "//a[@href='/be-the-buyer/in-production']/li/div[contains(text(),'In Production')]", :visible => true).click
    else
      page.find(:xpath, "//a[@href='/be-the-buyer/in-production']/li/div[contains(text(),'In Production')]", :visible => true).click
      wait_until {
        page.find(:xpath, "//h2[@class='page-title in-production']", :visible => true).text.should == 'In Production'
      }
  end
  wait_for_script
end

