require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it 'Visit to homepage.', :type => :request do

    go_to_BTB_page
    visit 'http://btb.demo.modcloth.com/in-progress'

    #within ('#data-product-id = 55605')do
    page.should have_link('Pick')
    #end
  end
end