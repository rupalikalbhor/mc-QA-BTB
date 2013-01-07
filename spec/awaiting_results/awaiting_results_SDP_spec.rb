# encoding: utf-8
require "spec/spec_helper"

describe 'SDP - Awaiting Results' do
  let(:page_title) { 'Awaiting Results' }

  before(:all) do
    go_to_BTB_page
  end

  context 'I. Breadcrumb' do
    it '1. Get first sample from grid' do
      go_to_awaiting_results_page
      First_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      get_sample_details(First_sample_product_id) #Get sample details from database
    end

    it '2. Verify when user clicks on sample image then user navigates to SDP' do
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div[@class = 'photo']/a", :visible => true).click
      wait_until {
        page.should have_xpath("//div[@class='sdp']")
      }
    end

    it '3. Verify breadcrumb displays in this format ModCloth » Be The Buyer » Voting In Progress » <Selected sample number>' , :no_phone => true do
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Awaiting Results » '+$sample_name
    end
  end

  context 'II. Left side section', :no_phone => true do
    it '1. Verify "Awaiting Results" section with correct text is displayed.' do
      within ('.state-instructions-sharing-section') do
        page.should have_content ('Awaiting Results')
        page.should have_content ("Tallying your votes. Leave feedback for the designer, too!")
      end
    end

    it '2. Verify voting hours left displayed.' do
      page.find(:xpath, "//div[@class = 'availability']", :visible => true).text.should == "Voting Ended on "+$voting_ends_at
    end

    it "3. Verify user see Details section with correct text" do
      within('.details-section') do
        page.should have_content('Details')
        page.should have_content "It's your chance to be a trendsetter! Does this dress have the right cut, color, and style? Do you think it should be produced and sold on ModCloth? You're the best critic, so vote now!"
      end
    end

    it "4. Verify user see Sign in comment button if user is not logged in." do
      page.should have_xpath("//div[@class = 'new-comment']/a[@href = '/be-the-buyer/sign_in']")
      page.find(:xpath, "//div[@class = 'new-comment']/a[@href = '/be-the-buyer/sign_in']",:visible => true).text.should == 'Sign In to Comment'
    end

    it "5. Verify when sample has atleast 1 comment then user see 'View x all comments' link", :no_phone => true do
      commentable_name = $sample_name
      expected_comment_count = get_comment_count(commentable_name)
      if (expected_comment_count.to_i > 0)
        page.find(:xpath, "//a[@href = '#comments']",:visible => true).text.should == "View All " +expected_comment_count+ " Comments"
        within ('.new-comment') do
          page.should have_link "View All " +expected_comment_count+ " Comments"
        end
      end
    end
  end

  context 'III. Sample detail box' do
    it '1. Verify sample name is displaying correctly' do
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div/div[@class='sample']/div[@class='name']",:visible => true).text.should == expected_sample_name
    end

    it '2. Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div/div[@class='sample']/div[@class = 'pin']",:visible => true)
    end

    it '3. Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div/div[@class='sample']/div[@class = 'price']",:visible => true).text.should == expected_sample_price
    end

    it '4. Verify all the samples on this page have "Keep Me Posted" button.' do
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix']/a",:visible => true).text.should == "KEEP ME POSTED"
    end
  end

  context 'IV. Right side widget' do
    it '1. Verify sample displays Vote count', :no_phone => true do
      expected_vote_count = $vote_count

      actual = page.find(:xpath, "//aside/div[@data-product-id="+First_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']",:visible => true).text
      actual_vote_count = actual.gsub(",", "")
      actual_vote_count.should == expected_vote_count
    end

    it '2. Verify sample displays comment count', :no_phone => true do
      commentable_name = $sample_name
      expected_comment_count = get_comment_count(commentable_name)
      page.find(:xpath, "//aside/div[@data-product-id="+First_sample_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']",:visible => true).text.should == expected_comment_count
    end

    it '3. Verify user see message "More Samples - Keep Voting!"', :no_phone => true do
      page.find(:xpath, "//div[@class = 'vote-more engagement-widget']",:visible => true).text.should == "More Samples - Keep Voting!"
    end

    it '4. Verify user do not see Your Sample section.', :no_desktop => true, :no_tablet => true do
      page.find(:xpath, "//div[@class = 'vote-more engagement-widget']").visible? == false
    end
  end

  context "V. Keep Me Posted functionality - Logged in user" do
    it '1. Verify user can sign in successfully.' do
      click_sign_in_link
      sign_in
      go_to_awaiting_results_page
    end

    it '2. Verify if a logged in user clicks on "Keep me posted" then
           - button changes to "We will Keep You Posted!" ' do
      #Get product id which is in 'Keep me posted' state
      Product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s

      if (Product_id != "")
        Before_comments_count = page.find(:xpath, "//div[@data-product-id="+Product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
        page.find(:xpath, "//div[@data-product-id ="+Product_id+"]/div[@class = 'photo']/a",:visible => true).click
        page.find(:xpath, "//div[@data-product-id ="+Product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix']/a",:visible => true).click
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+Product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix subscribed']/a",:visible => true).text.should == "WE'LL KEEP YOU POSTED!"
        page.driver.browser.navigate.refresh
        wait_for_script
        page.find(:xpath, "//div[@data-product-id ="+Product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix subscribed']/a",:visible => true).text.should == "WE'LL KEEP YOU POSTED!"
      else
        fail "No sample found in Awaiting Results section..so This test case is not executed."
      end
    end

    it "3. Verify user can change selection from 'We ll keep you posted' to 'Keep me Posted'." do
      page.find(:xpath, "//div[@class = 'sample-data']/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix subscribed']/a",:visible => true).click
      wait_for_script

      page.find(:xpath, "//div[@class = 'sample-data']/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix']/a",:visible => true).text.should == "KEEP ME POSTED"
      page.driver.browser.navigate.refresh
      wait_for_script
      page.find(:xpath, "//div[@class = 'sample-data']/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix']/a",:visible => true).text.should == "KEEP ME POSTED"
    end

    it '4. Verify user can comment on a sample in state "Awaiting Results".' do
      within('.new-comment') do
        fill_in 'new-comment-text', :with => 'Great Dress'
        click_button('Comment')
      end
      go_to_awaiting_results_page
      after_comments_count = page.find(:xpath, "//div[@data-product-id="+Product_id+"]/div[@class='counters']/div[@class='comments-count']",:visible => true).text
      after_comments_count.to_i.should == Before_comments_count.to_i + 1
    end
  end

  context 'VI. Arrows' do
    it "1. Verify when user is on 1st sample SDP page then user see only 'Next' arrow." do
      go_to_awaiting_results_page
      page.find(:xpath, "//div[@data-product-id="+First_sample_product_id+"]/div[@class = 'photo']/a",:visible => true).click
      wait_for_script
      wait_until {
        page.find(:xpath, "//div[@class='sdp']",:visible => true)
        page.find(:xpath, "//a[@class ='invisible prev']")
        page.find(:xpath, "//a[@class = 'next']",:visible => true)
        page.driver.browser.navigate.refresh
      }
    end

    it "2. Verify when user is on last sample SDP page then user see only 'Prev' arrow." do
      go_to_awaiting_results_page
      sample_count = get_awaiting_results_SampleCount
      if ($device_name == :phone)
        if (sample_count.to_i > 10)
          go_to_last_page
        end
      elsif ($device_name == :tablet || $device_name == :desktop)
        go_to_last_page
      end
      last_sample_product_id = page.evaluate_script("$('.sample-data:last').attr('data-product-id')").to_s
      page.find(:xpath, "//div[@data-product-id="+last_sample_product_id+"]/div[@class = 'photo']/a",:visible => true).click
      wait_for_script
      wait_until {
        page.find(:xpath, "//div[@class = 'sdp']",:visible => true)
        page.find(:xpath, "//a[@class = 'prev']",:visible => true)
        page.find(:xpath, "//a[@class = 'invisible next']")
                page.driver.browser.navigate.refresh
      }
    end

    it "3. Verify when user is NOT on 1st or last sample then user see both arrows." do
      go_to_awaiting_results_page
      second_sample_product_id = page.evaluate_script("$('.sample-data').eq(1).attr('data-product-id')").to_s
      page.find(:xpath, "//div[@data-product-id="+second_sample_product_id +"]/div[@class = 'photo']/a",:visible => true).click
      wait_for_script
      wait_until {
        page.find(:xpath, "//div[@class='sdp']",:visible => true)
        page.find(:xpath, "//a[@class = 'prev']",:visible => true)
        page.find(:xpath, "//a[@class = 'next']",:visible => true)
      }
      page.driver.browser.navigate.refresh
      wait_for_script
    end
  end

  context "VII. Sign out" do
    it '1. Verify user can sign out successfully.' do
      sign_out
      wait_for_script
    end
  end

  context "VIII. Logged out user functionality" do
    it '1. Register new user' do
      register_user
      wait_for_script
    end

    it '2. Go to 1st sample detail page' do
      go_to_awaiting_results_page
      wait_for_script
      go_to_SDP_page(First_sample_product_id)
    end

    it '3. Verify after clicking on "Sign in Comment" button and successful login user navigates back to SDP page.' do
      expected_url = current_url
      page.find(:xpath, "//div[@class = 'new-comment']/a").click
      wait_for_script
      sign_in()
      wait_for_script
      actual_url = current_url
      expected_url.should == actual_url
    end

    it "4. Verify user see 'Write a comment' text." do
      page.find(:xpath, "//textarea[@name = 'new-comment-text' and @placeholder = 'Write a comment...']")
      wait_for_script
    end

    it '5. Sign out' do
      sign_out
      wait_for_script
    end

    it 'BUGGG 6. Verify if a logged out user clicks on "Keep me posted" then after successful sign in, button changes to "We will Keep You Posted!" ' do
      go_to_awaiting_results_page
      wait_for_script
      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      page.find(:xpath, "//div[@data-product-id ="+first_sample_product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix']/a",:visible => true).click
      wait_for_script
      sign_in()
      wait_for_script
      visit(current_path)
      wait_until {
        page.find(:xpath, "//div[@data-product-id ="+first_sample_product_id+"]/div/div[@class = 'sample']/div[@class = 'voting-and-notification clearfix subscribed']/a",:visible => true).text.should == "WE'LL KEEP YOU POSTED!"
      }
    end

    it '7. Sign out' do
      sign_out
    end
  end
end

def go_to_last_page
  last_page_number = page.evaluate_script("$('.bottom-pagination .pagination .pages .next_page').prev().text()").to_s
  page.find(:xpath, "//div[@class = 'bottom-pagination']/div/span[@class = 'pages']/a[@href ='/be-the-buyer/awaiting-results?page="+last_page_number+"']",:visible => true).click
  wait_for_script
end