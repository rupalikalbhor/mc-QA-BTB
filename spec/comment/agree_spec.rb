require 'support/agree_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Posting comment on a sample for a logged-in user' do
  before(:all) do
    go_to_BTB_page
    sign_in
    wait_for_script
  end

  context '1. Verify user can agree to a comment by other users.', :type => :request do
    it 'Clicking on "Agree" link changes to "You Agree"' do
      go_to_SDP
      find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/span/a").click
      page.driver.browser.navigate.refresh
      find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/span/a").text.should eq('You Agree')
    end

    it 'Verify after user agrees, the number of agrees increment.' do
      find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/span/span").text.should eq('1')
    end

    it 'Clicking on "You Agree" link changes to "Agree"' do
      find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/span/a").click
      visit page.driver.browser.current_url
      find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/span/a").text.should eq('Agree')
    end

    it 'Verify after user undoes agree, the number of agrees decrement.' do
      page.should_not have_xpath("//div[@data-comment-id=#{$comment_id}]/div/span/span")
    end
  end


  #it '4. Verify user does not see "Agree" link on his own comment/reply.' do
  #go_to_SDP_page_for_login_user
  #verify_no_agree_link
  #end

  #it ' 5. Verify user can see number of agrees on his comment/reply.' do
  # go_to_SDP_page_agree
  # verify_agree_count_others
  #end


  #it '7. Verify user can agree to comment/reply in section "Top Comments". ' do

  #end

  #it '8. Verify for no agrees on any comment, the Agree icon(thumbs-up icon) is not visible.' do

  #end

end


