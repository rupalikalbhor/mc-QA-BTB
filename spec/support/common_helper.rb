require "spec_helper"
require 'support/data_helper'
require 'support/query_helper'

def go_to_BTB_page
  visit '/'
end

def wait_for_script
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

def sign_in()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-join']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  visit '/'
  wait_for_script
  should_be_signed_in_as_user($user)
end

def should_be_signed_in_as_user(user)
  name = $first_name
  #name = user_data['first-name'].to_s
  short_name = get_short_name(name)
  should_be_signed_in_with_name(short_name)
end

def get_short_name(name)
  if (name == '')
    email = user_data['email'].to_s
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
