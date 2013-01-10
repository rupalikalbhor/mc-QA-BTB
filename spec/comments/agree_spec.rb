#require 'spec/support/common_helper'
require "spec/spec_helper"
#require 'spec/support/query_helper'

describe 'Comments - Agree_spec' do
  before(:all) do
    go_to_BTB_page
    click_sign_in_link
    sign_in
  end

  context 'I. Verify user can agree to a comment by other users.' do
    it '1. Clicking on "Agree" link changes to "You Agree"' do
      go_to_SDP_with_comments()
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      Comment_id = page.evaluate_script("$('div[class="+'agree'+"]').eq(0).parent().parent().attr('data-comment-id')").to_s

      if (Comment_id == nil)
        puts " CAN NOT EXECUTE AGREE TEST CASES..."
      else
        page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a", :visible => true).click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
        end
        page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a", :visible => true).text.should eq('You Agree')
      end
    end

    it '2. Clicking on "You Agree" link changes to "Agree"' do
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a", :visible => true).click
      page.find(:xpath, "//div[@data-comment-id=#{Comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a", :visible => true).text.should eq('Agree')
    end

    it '3. Verify after user agrees comment then agree count gets incremented.' do
      Agreed_comment_id = page.evaluate_script("$('div[class="+'agree'+"]').eq(0).parent().parent().attr('data-comment-id')").to_s
      value = page.should have_no_xpath("//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/span")
      if (value == false)
        expected_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/span", :visible => true).text
      else
        expected_agree_count = 0
      end
      page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree']/a", :visible => true).click
      page.driver.browser.navigate.refresh
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      Actual_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/span", :visible => true).text
      Actual_agree_count.to_i.should == (expected_agree_count.to_i + 1)
    end

    it '4. Verify after user undoes agree, the number of agrees decrement.' do
      page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/a", :visible => true).click
      expected_agree_count = page.find(:xpath, "//div[@data-comment-id=#{Agreed_comment_id}]/div[@class = 'metadata']/div[@class = 'agree agreed']/span", :visible => true).text
      Actual_agree_count.to_i.should == expected_agree_count.to_i
    end

    #it '7. Verify user can agree to comment/reply in section "Top Comments". ' do
    #end

    #it '8. Verify for no agrees on any comment, the Agree icon(thumbs-up icon) is not visible.' do
    #end
  end
end

# This function will navigate user to SDP where sample has atleast 1 comment
def go_to_SDP_with_comments()
  sample_count = get_voting_in_progress_SampleCount()
  i = 1
  if (sample_count.to_i !=0)
    begin
      page.find(:xpath, "//div[@class = 'comments-count']", :visible => true)
      comment_count = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'counters']/div[@class = 'comments-count']").text
      if (comment_count.to_i > 0)
        sample_name = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'name']").text
        page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a").click
        page.find(:xpath, "//div[@class = 'name']", :visible => true).text.should == sample_name
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