# encoding: utf-8
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'Grid page - Awaiting Results' do
  let(:page_title) { 'Awaiting Results' }
  expected_sample_count = get_awaiting_results_SampleCount

  before(:all) do
    go_to_BTB_page
    wait_for_script
    go_to_awaiting_results_page
  end

  context "A. UI" do
    it '1. Verify "Awaiting Results" link is loading correct page.' do
      go_to_awaiting_results_page
    end

    it '2. Verify page title is correct', :no_phone => true do
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title awaiting-results']").text.should == page_title
    end

    it '3. Verify when user clicks on BTB logo then user navigates to BTB homepage' do
      page.find(:xpath, "//div[@id = 'btb-logo']").click
      wait_for_script
      page.should have_content('Voting In Progress')
    end

    it '4. Verify pagination displays correctly' do
      go_to_awaiting_results_page
      case $device_name
        when :phone
          if (expected_sample_count.to_i < 10)
            page.find(:xpath, "//span[@class = 'page-info']").text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']").text.should == 'Showing 1 - 10' + ' of ' + expected_sample_count
          end

        else
          if (expected_sample_count.to_i < 24)
            page.find(:xpath, "//span[@class = 'page-info']").text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']").text.should == 'Showing 1 - 24 of ' + expected_sample_count
          end
      end
    end

    it '6. Verify breadcrumb displays correct sequence with text', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Awaiting Results'
    end

    it '7. Verify clicking on breadcrumb links load relevant pages.', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]").click
      page.should have_xpath("//a[@id = 'modcloth_logo']")

      go_to_awaiting_results_page
      wait_for_script

      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]").click
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end
  end

  context 'B. Sample Box' do
    before (:all) do
      go_to_awaiting_results_page
    end
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

    it '4. Verify all the samples on this page have "KEEP ME POSTED" button.' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix']/a").text.should == "KEEP ME POSTED"
    end

    it '5. Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      vote_count = page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'vote-count']").text
      actual_vote_count = vote_count.gsub(",", "")
      expected_vote_count.should == actual_vote_count
    end

    it '6. Verify sample displays comment count' do
      commentable_name = $sample_name
      expected_comment_count = get_voting_in_progress_CommentCount(commentable_name)
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'comments-count']").text.should == expected_comment_count
    end

    it '7. Verify sample displays "Voting End date" with clock icon.' do
      voting_ends_at_from_db = $voting_ends_at
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'awaiting-results status']").text.should == "Ended "+voting_ends_at_from_db
    end

    it '8. Verify when user clicks on sample image then user navigates to SDP' do
      sample_number = $sample_name.gsub("Sample ", '')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']").click
      page.should have_xpath("//div[@class='sdp']")
      go_to_BTB_page
    end
  end

  context "C. Keep Me Posted functionality - Logged in user" do
    it '1. Verify user can sign in successfully.' do
      go_to_awaiting_results_page
      wait_for_script
      click_sign_in_link
      sign_in
    end

    it '2. Verify if a logged in user clicks on "Keep me posted" then
         - button changes to "We will Keep You Posted!" ' do
      keep_me_posted_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s

      if (keep_me_posted_product_id != "")
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix']/a").click
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a").text.should == "WE'LL KEEP YOU POSTED!"

        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a").text.should == "WE'LL KEEP YOU POSTED!"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end

    it '3. Verify user can comment on a sample in state "Awaiting Results".' do
      product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      if (product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class = 'photo']/a").click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end
        go_to_awaiting_results_page
        wait_for_script
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class='counters']/div[@class='comments-count']").text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end

    it "4. Verify user can change selection from 'We ll keep you posted' to 'Keep me Posted'." do
      keep_me_posted_product_id1 = page.evaluate_script('$("div[class=\"voting-and-notification clearfix subscribed\"]").eq(0).parent().attr("data-product-id")').to_s

      if (keep_me_posted_product_id1 != "")
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix subscribed']/a").click
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix']/a").text.should == "KEEP ME POSTED"
        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix']/a").text.should == "KEEP ME POSTED"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end
    after (:all) do
      sign_out
    end
  end

  context "BUGGGG - D. Keep Me Posted functionality - Logged out user" do
    it "1. Logged out - Verify when user clicks on 'Keep me posted' then user see login in window, after successful login -
    Button changes to 'We'll keep you posted'" do

      product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      if (product_id != "")
        page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix']/a").click

        wait_for_script
        sign_in
        page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a").text.should == "WE'LL KEEP YOU POSTED!"

        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a").text.should == "WE'LL KEEP YOU POSTED!"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end
  end
end

