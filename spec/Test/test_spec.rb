require 'spec/spec_helper'
describe 'Testing' do

  it 'Visit to homepage.', :type=>:request do
    puts 'enter iinto test heyyyy'
    visit 'http://www.modcloth.com'
    puts 'site exit !!!!!!!'
  end
end