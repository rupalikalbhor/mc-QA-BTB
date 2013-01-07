# encoding: utf-8
#require 'spec/support/common_helper'
require 'spec/support/query_helper'
require "spec/spec_helper"

describe 'Grid page - Voting In Progress' do
  let(:page_title) { 'Voting In Progress' }
  expected_sample_count = get_voting_in_progress_SampleCount

  before(:all) do
    go_to_BTB_page
  end

  context "A. UI" do
    it '1. Verify "Voting In Progress" link is loading correct page.' do
      go_to_voting_in_progress_page
    end

    it '2. Verify page title is correct', :no_phone => true do
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']", :visible => true).text.should == page_title
    end

    it '3. Verify when user clicks on BTB logo then user navigates to BTB homepage' do
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true).click
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'menu-dropdown']/div", :visible => true).text.should == "Voting In Progress"
      else
        page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Voting In Progress'
      end
    end

    it '4. Verify pagination displays correctly' do
      case $device_name
        when :phone
          if (expected_sample_count.to_i < 10)
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing 1 - 10' + ' of ' + expected_sample_count
          end

        else
          if (expected_sample_count.to_i < 22)
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
          end

      end
    end

    it '5. Verify user sees "Your Sample" section with correct title' do
      page.find(:xpath, "//h2[@id = 'your-samples-header']", :visible => true).text.should == 'YOUR SAMPLES'
    end

    it '6. Verify breadcrumb displays correct sequence with text', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end

    it '7. Verify clicking on breadcrumb links load relevant pages.', :no_phone => true do
      visit '/'
      wait_for_script
      expected_url = current_url
      go_to_voting_in_progress_page
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]", :visible => true).click
      if($device_name == :tablet)
        page.find(:xpath, "//div[@id = 'mc-header']/a", :visible =>true)
        expected_url.should == current_url
      else
        page.find(:xpath, "//div[@id = 'header']/a", :visible =>true)
        expected_url.should == current_url
      end
      go_to_voting_in_progress_page
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]", :visible => true).click
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end

    #it '7. Verify clicking on breadcrumb links load relevant pages.', :no_phone => true do
    #  page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]", :visible => true).click
    #  actual_url = current_url
    #  visit '/'
    #  wait_until {
    #    current_url.should == actual_url
    #  }
    #  go_to_voting_in_progress_page
    #
    #  visit '/'+'be-the-buyer/voting-in-progress'
    #  wait_for_script
    #
    #  actual_url1 = current_url
    #
    #  page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]", :visible => true).click
    #  wait_until {
    #    current_url.should == actual_url1
    #  }
    #end
  end

  context 'B. Sample Box' do
    it '' do
      FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      get_sample_details(FIRST_SAMPLE_PRODUCT_ID) #Get sample details from database
    end

    it '1. Verify sample number is displaying correctly' do
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='name']",:visible =>true).text.should == expected_sample_name
    end

    it '2. Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'pin']",:visible =>true)
    end

    it '3. Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'price']",:visible =>true).text.should == expected_sample_price
    end

    it '4. Verify all the samples on this page have "Pick","Skip" buttons.' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'skip']",:visible =>true).text.should == "SKIP"
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'pick']",:visible =>true).text.should == "PICK"
    end

    it '5. Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      vote_count = page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'vote-count']",:visible =>true).text
      actual_vote_count = vote_count.gsub(",", "")
      expected_vote_count.should == actual_vote_count
    end

    it '6. Verify sample displays comment count' do
      commentable_name = $sample_name
      expected_comment_count = get_comment_count(commentable_name)
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'comments-count']",:visible =>true).text.should == expected_comment_count
    end

    it '7. Verify sample displays "Voting End date" with clock icon.' do
      voting_time_from_db = $voting_time
      expected_voting_time = get_voting_date_time(voting_time_from_db)
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'status voting-in-progress']",:visible =>true).text.should == expected_voting_time
    end

    it '8. Verify when user clicks on sample image then user navigates to SDP' do
      sample_number = $sample_name.gsub("Sample ", '')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']",:visible =>true).click
      page.should have_xpath("//div[@class='sdp']")
      go_to_BTB_page
    end
  end

  context "C. Pick or Skip functionality - Logged in user" do
    it '1. Verify when user clicks on "join" link, after successful join user navigates back to BTB page.' do
      go_to_voting_in_progress_page
   #   visit '/'+'be-the-buyer/voting-in-progress'
      expected_url = current_url
      join()
      current_url.should == expected_url
    end

    it '2. Verify if a logged in user clicks on "Pick" then
       - button changes to "Picked,
       - Pick violater displays on sample image.
       - voting count increments by 1.' do
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).click
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).text.should == "SKIP"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).text.should == "PICKED"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator picked']",:visible => true)
        }
        after_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to pick..so This test case is not executed."
      end
    end

    it '4. Verify if a logged in user clicks on "Skip" then voting count increments by 1.' do
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).click
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).text.should == "SKIPPED"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).text.should == "PICK"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator skipped']",:visible => true)
        }
        after_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to skip..so This test case is not executed."

      end
    end

    it '5. Verify user can post comment on a sample which he has picked.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).click
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a",:visible => true).click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end
        go_to_BTB_page
        wait_for_script
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '6. Verify user can post comment on a sample which he has skipped.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix skipped\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).click
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a",:visible => true).click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end
        go_to_BTB_page
        wait_for_script
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '7. Verify after user changes the vote, vote count remains unchangeed.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_vote_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).click
        page.driver.browser.navigate.refresh
        wait_for_script
        after_vote_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        after_vote_count.to_i.should == before_vote_count.to_i
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end
  end

  context "D. Sign out functionality" do
    it '1. Verify when user clicks on "Sign out" link then user successfully signed out' do
      sign_out
    end
  end

  context "E. Sign In functionality" do
    it '1. Verify user successfully Sign in and after successful sign in user navigates back to BTB page.' do
      expected_url = current_url
      click_sign_in_link
      sign_in
      current_url.should == expected_url
      sign_out
    end
  end

  #Scripts are failing because of BUG
  context "BUGGG F. Pick or skip functionality - Logged out user" do
    it ' 1. Verify when user click on "Pick" button, Log in window gets displayed and upon successful login following operations happens -
        - button changes to "Picked,
        - Pick violater displays on sample image.
        - voting count increments by 1.' do
      go_to_voting_in_progress_page
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).click
        sign_in()
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).text.should == "SKIP"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).text.should == "PICKED"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator picked']",:visible => true)
        }
        after_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
        sign_out
      else
        fail "No sample found to pick..so This test case is not executed."
      end

    end

    it ' 2. Verify when user click on "Skip" button, Log in window gets displayed and upon successful login following operations happens -
            - button changes to "Skipped,
            - Skip violater displays on sample image.
            - voting count increments by 1.' do
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).click
        sign_in()
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']",:visible => true).text.should == "SKIPPED"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']",:visible => true).text.should == "PICK"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator skipped']",:visible => true)
        }
        after_vote_count1 = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']",:visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
        sign_out
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end
  end
end


