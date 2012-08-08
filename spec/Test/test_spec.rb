require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'

describe 'Testing' do
  it 'Visit to homepage.', :type => :request do

    #puts 'Enter into test Yay!!!'
    #visit 'http://www.modcloth.com'
    #puts 'Site exit !!!!!!!'
    #page.should have_content ("Sign out")

    url = connection
    puts url

    #visit '/'
    #sign_in('stage_sign_in')
  end
end