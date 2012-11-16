# encoding: utf-8
require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

#describe 'Testing' do
#  it '3. Verify after clicking on "Sign in Comment" button and successful login user navigates back to SDP page.' do
#
#    visit 'http://btb-ecomm.demo.modcloth.com/be-the-buyer/samples/66076-sample-2402'
#    wait_for_script
#    #click_sign_in_link()
#    #sign_in()
#
#    #//input[@name='q' and ancestor-or-self::*[@name='f']]
#    find(:xpath, "//div[@class='agree']/a['Agree'] and ancestor-or-self::*[@class = 'comment']").text
#    #find(:xpath, "//div[@data-comment-id:]")
#    find(:xpath, "//div[@class='agree']/a['Agree']").click
#    sleep(15)
#    #find(:xpath, "//div[@data-comment-id=#{agree_comment_id}]/div/div/a").click
#    #agree_comment_id = page.evaluate_script("$('div.agree > a:eq("+"Agree"+")').parent().parent().parent().attr('data-comment-id')").to_s
#    #puts "Agree comment id: #{agree_co
#    #mment_id}"
#    #find(:xpath, "//div[@data-comment-id=#{agree_comment_id}]/div/div/a").click
#    #wait_for_script()
#    #sleep(15)
#    find(:xpath, "//div[@data-comment-id=#{agree_comment_id}]/div/div/a").text.should == 'You Agree'
#  end
#end
#----------------------------------------------------------

describe 'Agree - Logged-in user' do
  before(:all) do
    go_to_BTB_page
    click_sign_in_link
    sign_in
    wait_for_script
  end

  context '1. Verify user can agree to a comment by other users.' do
    it 'Clicking on "Agree" link changes to "You Agree"' do
      get_sample_name_with_comment()
      Comment_id = page.evaluate_script("$('div[class="+'agree'+"]').eq(0).parent().parent().attr('data-comment-id')").to_s
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a").click
      page.driver.browser.navigate.refresh
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a").text.should eq('You Agree')
    end

    it 'Clicking on "You Agree" link changes to "Agree"' do
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a").click
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a").text.should eq('Agree')
    end

    it 'Verify after user agrees then agree count gets incremented.' do
      Agreed_comment_id = page.evaluate_script("$('div[class="+'agree'+"]').eq(0).parent().parent().attr('data-comment-id')").to_s
      value = page.has_no_xpath?("//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/span")
      if (value == false)
        expected_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/span").text
      else
        expected_agree_count = 0
      end
      page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a").click
      page.driver.browser.navigate.refresh
      Actual_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/span").text
      Actual_agree_count.to_i.should == (expected_agree_count.to_i + 1)
    end

    it 'Verify after user undoes agree, the number of agrees decrement.' do
      page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a").click
      expected_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/span").text
      Actual_agree_count.to_i.should == expected_agree_count.to_i
    end
  end
end

def get_sample_name_with_comment()
  sample_count = get_voting_in_progress_SampleCount
  i = 1
  if (sample_count.to_i !=0)
    begin
      comment_count = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'counters']/div[@class = 'comments-count']").text
      if (comment_count.to_i > 0)
        sample_name = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'name']").text
        page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a").click
        wait_for_script
        break
      else
        i = i+1
      end
    end while (i != sample_count)
  else
    fail "There are no samples in Voting in progress tab.."
  end
  return sample_name
end








