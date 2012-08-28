require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it 'Visit to homepage.', :type => :request do

    go_to_BTB_page
    #visit 'http://btb.demo.modcloth.com/in-progress'

    #within ('#data-product-id = 55605')do
    #page.should have_link('Pick')
    #get_voting_in_progress_SampleDetails
    #puts get_voting_in_progress_SampleCount
    #get_voting_in_progress_CommentCount
    #end

    puts "Sample count is: #{get_voting_in_progress_SampleCount}"
  end
end