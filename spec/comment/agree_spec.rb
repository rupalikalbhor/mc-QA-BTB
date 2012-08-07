require 'support/agree_helper'

describe 'Posting comment on a sample for a logged-in user' do
  before(:each) do
    go_to_BTB_page
    go_to_SDP_page
  end

  it '1. Verify user can agree to a comment by other users', :type => :request do
   verify_agree_comment
  end
end
