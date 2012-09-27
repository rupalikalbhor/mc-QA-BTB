# encoding: utf-8
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'Grid page - Voting In Progress' do
  let(:page_title) { 'Voting In Progress' }
  expected_sample_count = get_voting_in_progress_SampleCount

  before(:all) do
    go_to_BTB_page
    wait_for_script
  end

  context "A. UI" do
    it '1. Verify "Voting In Progress" link is loading correct page.' do
      go_to_voting_in_progress_page
    end

    it '2. Verify page title is correct', :no_phone => true do
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == page_title
    end

    it '3. Verify when user clicks on BTB logo then user navigates to BTB homepage' do
      page.find(:xpath, "//div[@id = 'btb-logo']").click
      wait_for_script
      page.should have_content('Voting In Progress')
    end

    it '2. Verify pagination displays correctly' do
      case $device_name
        when :phone
          page.find(:xpath, "//div[@class = 'pagination phone']").text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
        else
          page.find(:xpath, "//div[@class = 'pagination not-phone']").text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
      end
    end

    it '3. Verify user sees "Your Sample" section with correct title' do
      page.find(:xpath, "//h2[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
    end

    it '4. Verify breadcrumb displays correct sequence with text', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end

    it '5. Verify clicking on breadcrumb links load relevant pages.', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]").click
      go_to_voting_in_progress_page
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]").click
      go_to_voting_in_progress_page
    end

    it '6. Verify all samples have image' do
      sample_count = page.body.match(/of (\d+)/)[1]
      i = 1
      case $device_name
        when :desktop
          while (i != sample_count.to_i+1) do
            page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a/img[@class = 'primary' and @src[contains(.,'http://s3.amazonaws.com/')]]")
            page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a/img[@class = 'alternate' and @src[contains(.,'http://s3.amazonaws.com/')]]")
            i = i+1
          end
        else
          while (i != sample_count.to_i+1) do
            page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a/div/div[@class = 'flex-viewport']/ul/li[@class='flex-active-slide']/img[@src[contains(.,'http://s3.amazonaws.com/')]]")
            i = i+1
          end
      end
    end
  end

  context 'B. Sample Box' do
    it '' do
      FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      get_voting_in_progress_SampleDetails(FIRST_SAMPLE_PRODUCT_ID) #Get sample details from database
    end

    it '1. Verify sample number is displaying correctly' do
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='name']").text.should == expected_sample_name
    end

    it '2. Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'pin']")
    end

    it '3. Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'price']").text.should == expected_sample_price
    end

    it '4. Verify all the samples on this page have "Pick","Skip" buttons.' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'skip']").text.should == "SKIP"
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'pick']").text.should == "PICK"
    end

    it '5. Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'vote-count']").text.should == expected_vote_count
    end

    it '6. Verify sample displays comment count' do
      commentable_name = $sample_name
      expected_comment_count = get_voting_in_progress_CommentCount(commentable_name)
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'comments-count']").text.should == expected_comment_count
    end

    it '7. Verify sample displays "Voting End date" with clock icon.' do
      voting_time_from_db = $voting_time
      expected_voting_time = get_voting_date_time(voting_time_from_db)
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'status voting-in-progress']").text.should == expected_voting_time
    end

    it '8. Verify when user clicks on sample image then user navigates to SDP' do
      sample_number = $sample_name.gsub("Sample ", '')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']").click
      page.should have_xpath("//div[@class='sdp']")
      go_to_BTB_page
    end
  end

  context "C. Pick or Skip functionality - Logged in user" do
    it '1. Verify user successfully Sign in' do
      sign_in
      go_to_voting_in_progress_page
    end
    #it '1. Verify when user clicks on "Pick" button then button changes to "Picked, Pick violater displays on sample image."
    #2. Verify when user clicks on "Skip" button then button changes to "Skipped, Skip violater displays on sample image.' do
    #  sign_in
    #  go_to_voting_in_progress_page
    #  first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
    #  voting_status = page.evaluate_script("$('.sample-data').attr('data-vote-value')").to_s
    #  if (voting_status == "pick")
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").click
    #    page.driver.browser.navigate.refresh
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIPPED"
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICK"
    #    page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator picked']")
    #
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").click
    #    page.driver.browser.navigate.refresh
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIP"
    #    page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICKED"
    #    page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator skipped']")
    #  else
    #    if (voting_status == "skip")
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").click
    #      page.driver.browser.navigate.refresh
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIP"
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICKED"
    #      page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator picked']")
    #
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").click
    #      page.driver.browser.navigate.refresh
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIPPED"
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICK"
    #      page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator skipped']")
    #    else
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").click
    #      page.driver.browser.navigate.refresh
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIP"
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICKED"
    #      page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator picked']")
    #
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").click
    #      page.driver.browser.navigate.refresh
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIPPED"
    #      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICK"
    #      page.should have_xpath("//div[@data-product-id="+first_sample_product_id+"]/div[@class='violator skipped']")
    #    end
    #  end
    #end

    it '3. Verify if a logged in user clicks on "Pick" then
       - button changes to "Picked,
       - Pick violater displays on sample image.
       - voting count increments by 1.' do
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']").click
        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIP"
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICKED"
        page.should have_xpath("//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator picked']")
        after_vote_count = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to pick..so This test case is not executed."
      end
    end

    it '4. Verify if a logged in user clicks on "Skip" then voting count increments by 1.' do
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        before_vote_count = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']").click
        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-skip']").text.should == "SKIPPED"
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/a[@href = '#vote-pick']").text.should == "PICK"
        page.should have_xpath("//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='violator skipped']")
        after_vote_count = page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to skip..so This test case is not executed."

      end
    end

    it '5. Verify user can post comment on a sample which he has picked.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-pick']").click
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a").click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end

        go_to_BTB_page
        wait_for_script
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '6. Verify user can post comment on a sample which he has skipped.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix skipped\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-pick']").click
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a").click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end

        # within('#breadcrumbs') do
        #   click_link 'Voting In Progress'
        # end
        go_to_BTB_page
        wait_for_script
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '7. Verify after user changes the vote, vote count remains unchangeed.' do
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        before_vote_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/a[@href = '#vote-skip']").click
        page.driver.browser.navigate.refresh
        wait_for_script
        after_vote_count = page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class='counters']/div[@class='vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end
  end

  context "E. Sign out functionality" do
    it '1. Verify when user clicks on "Sign out" link then user successfully signed out' do
      wait_for_script
      sign_out
    end
  end


  context "D. Pick or skip functionality - Logged out user" do

  end

  context "F. Join functionality" do
    it '1. Verify when user clicks on "join" link, after successful join user navigates back to BTB page.' do
      go_to_voting_in_progress_page
      expected_url = current_url
      join()
      current_url.should == expected_url
      sign_out
    end
  end
end

def get_voting_date_time(expected_voting_time)
  strlength = expected_voting_time.length
  days = expected_voting_time[0, 1]+"d"+" "

  if (strlength > 8)
    hours = expected_voting_time[strlength - 8, 2]
    if (hours != "00")
      hours_first_number = hours[0, 1]

      if (hours_first_number == '0')
        hours = hours[1, 1]+"h"
      else

        hours = hours+"h"
      end
      voting_days = days + hours

    else
      voting_days = days
    end
  else
    hours = expected_voting_time[0, 2]
    if (hours != "00")
      hours_first_number = hours[0, 1]

      if (hours_first_number == '0')
        hours = hours[1, 1]+"h"
      else
        hours = hours+"h"
      end
      voting_days = hours
    else
      minutes = expected_voting_time[3, 2]
      minutes_first_number = minutes[0, 1]
      if (minutes_first_number == '0')
        minutes = minutes[1, 1]+"m"
      else
        minutes = minutes+"m"
      end
      voting_days = minutes
    end
  end
  return voting_days
end

def go_to_voting_in_progress_page
  go_to_BTB_page
  case $device_name
    when :phone
      page.find(:xpath, "//div[@id='menu-toggle']").click
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
      page.find(:xpath, "//div[@id = 'menu-toggle']").text.should == "Voting In Progress"
    else
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == 'Voting In Progress'
  end
end
