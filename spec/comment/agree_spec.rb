require 'support/agree_helper'
require 'support/common_helper'

describe 'Posting comment on a sample for a logged-in user' do
  before(:each) do
    go_to_BTB_page
    go_to_SDP_page
  end

  it '1. Verify user can agree to a comment by other users', :type => :request do
    verify_agree
  end

  it '2. Verify after user agrees, link changes to "You Agree".' do

  end
  it '3. Verify after user agrees, the number of agrees increment.' do

  end

  it '4. Verify user does not see "Agree" link on his own comment/reply' do

  end

  it ' 5. Verify user can see number of agrees on his comment/reply' do

  end

  it '6. Verify user can change his response by clicking on "You agree". The link should change to "Agree" and the no. of agrees should decrement. '  do

  end

  it '7. Verify user can agree to comment/reply in section "Top Comments". ' do

  end

  it '8. Verify for no agrees on any comment, the Agree icon(thumbs-up icon) is not visible.' do

  end

end


