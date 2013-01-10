# encoding: utf-8
require "spec/spec_helper"

describe 'In Production - in_production_grid_spec' do
  let(:page_title) { 'In Production' }
  expected_sample_count = get_in_production_SampleCount

  before(:all) do
    go_to_BTB_page
  end

  context "I. UI" do
    it '1. Verify "In Production" link is loading correct page.' do
      go_to_in_production_page
    end

    it '2. Verify page title is correct', :no_phone => true do
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title in-production']", :visible => true).text.should == page_title
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
      go_to_in_production_page
      case $device_name
        when :phone
          if (expected_sample_count.to_i < 10)
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing 1 - 10' + ' of ' + expected_sample_count
          end

        else
          if (expected_sample_count.to_i < 24)
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing all '+expected_sample_count+ ' items'
          else
            page.find(:xpath, "//span[@class = 'page-info']", :visible => true).text.should == 'Showing 1 - 24 of ' + expected_sample_count
          end
      end
    end

    it '6. Verify breadcrumb displays correct sequence with text', :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » In Production'
    end

    it '7. Verify clicking on breadcrumb links load relevant pages.', :no_phone => true do

      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]", :visible => true).click
      if ($device_name == :tablet)
        page.find(:xpath, "//div[@id = 'mc-header']/a", :visible => true)

      else
        page.find(:xpath, "//div[@id = 'header']/a", :visible => true)
      end
      go_to_awaiting_results_page
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]", :visible => true).click
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end
  end

  context 'II. Sample Box' do
      before (:all) do
        go_to_in_production_page
      end
      it '' do
        First_awaiting_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
        get_sample_details(First_awaiting_sample_product_id) #Get sample details from database
      end

      it '1. Verify sample number is displaying correctly' do
        expected_sample_name = $sample_name #Get sample name from database
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class='name']", :visible => true).text.should == expected_sample_name
      end

      it '2. Verify pin icon is displaying in sample box' do
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class = 'pin']", :visible => true)
      end

      it '3. Verify correct dollar amount appears above each sample' do
        expected_sample_price = $sample_price
        expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class = 'price']", :visible => true).text.should == expected_sample_price
      end

      it '4. Verify all the samples on this page have "KEEP ME POSTED" button.' do
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class = 'voting-and-notification clearfix']/a", :visible => true).text.should == "KEEP ME POSTED"
      end

      it '5. Verify sample displays Vote count' do
        expected_vote_count = $vote_count
        vote_count = page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div/div[@class = 'vote-count']", :visible => true).text
        actual_vote_count = vote_count.gsub(",", "")
        expected_vote_count.should == actual_vote_count
      end

      it '6. Verify sample displays comment count' do
        commentable_name = $sample_name
        expected_comment_count = get_comment_count(commentable_name)
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div/div[@class = 'comments-count']", :visible => true).text.should == expected_comment_count
      end

      it '7. Verify sample displays "Voting End date" with clock icon.' do
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class = 'in-production status']", :visible => true).text.should == "Available Soon"
      end

      it '8. Verify when user clicks on sample image then user navigates to SDP' do
        sample_number = $sample_name.gsub("Sample ", '')
        page.find(:xpath, "//div[@data-product-id="+First_awaiting_sample_product_id+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+First_awaiting_sample_product_id+"-sample-"+sample_number+"']", :visible => true).click
        page.should have_xpath("//div[@class='sdp']")
        go_to_BTB_page
      end
  end

  context "III. Keep Me Posted functionality - Logged in user" do
    it '1. Verify user can sign in successfully.' do
      go_to_in_production_page
      click_sign_in_link
      sign_in
    end

    it '2. Verify if a logged in user clicks on "Keep me posted" then
         - button changes to "We will Keep You Posted!" ' do
      keep_me_posted_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s

      if (keep_me_posted_product_id != "")
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix']/a", :visible => true).click
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a", :visible => true).text.should == "WE'LL KEEP YOU POSTED!"

        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a", :visible => true).text.should == "WE'LL KEEP YOU POSTED!"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end

    it '3. Verify user can comment on a sample in state "Awaiting Results".' do
      product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      if (product_id != "")
        before_comments_count = page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class='counters']/div[@class='comments-count']", :visible => true).text
        page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class = 'photo']/a", :visible => true).click
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
        end
        go_to_in_production_page
        after_comments_count = page.find(:xpath, "//div[@data-product-id="+product_id+"]/div[@class='counters']/div[@class='comments-count']", :visible => true).text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end

    it "4. Verify user can change selection from 'We ll keep you posted' to 'Keep me Posted'." do
      keep_me_posted_product_id1 = page.evaluate_script('$("div[class=\"voting-and-notification clearfix subscribed\"]").eq(0).parent().attr("data-product-id")').to_s

      if (keep_me_posted_product_id1 != "")
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix subscribed']/a", :visible => true).click
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix']/a", :visible => true).text.should == "KEEP ME POSTED"
        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+keep_me_posted_product_id1+"]/div[@class = 'voting-and-notification clearfix']/a", :visible => true).text.should == "KEEP ME POSTED"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end
    after (:all) do
      sign_out
    end
  end

  context "BUGGGG - IV. Keep Me Posted functionality - Logged out user" do
      it "1. Logged out - Verify when user clicks on 'Keep me posted' then user see login in window, after successful login -
      Button changes to 'We'll keep you posted'" do

        product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
        if (product_id != "")
          page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix']/a", :visible => true).click
          wait_for_script
          sign_in
          page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a", :visible => true).text.should == "WE'LL KEEP YOU POSTED!"

          page.driver.browser.navigate.refresh
          wait_for_script
          page.find(:xpath, "//div[@data-product-id ="+product_id+"]/div[@class = 'voting-and-notification clearfix subscribed']/a", :visible => true).text.should == "WE'LL KEEP YOU POSTED!"
        else
          fail "No sample found in Awaiting Results section..so This test case is not executed."
        end
      end
    end
end
