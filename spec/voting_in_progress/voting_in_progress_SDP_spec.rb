# encoding: utf-8
require "spec/spec_helper"

describe 'Voting_in_progress - Voting_in_progress_SDP_spec' do
  let(:page_title) { 'Voting In Progress' }

  before(:all) do
    go_to_BTB_page
  end

  it '1. Get first sample from grid' do
    go_to_voting_in_progress_page
    #wait_for_script
    First_Voting_SDP_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
    get_sample_details(First_Voting_SDP_sample_product_id) #Get sample details from database
  end

  it '2. Verify when user clicks on sample image then user navigates to SDP' do
    page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div[@class = 'photo']/a", :visible => true).click
    wait_until {
      page.should have_xpath("//div[@class='sdp']")
    }
  end

  context 'A. Breadcrumb', :no_phone => true do
    it 'Verify breadcrumb displays in this format ModCloth » Be The Buyer » Voting In Progress » <Selected sample number>' do
      page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text.should == 'ModCloth » Be The Buyer » Voting In Progress » '+$sample_name
    end
  end

  context 'B. Left side section', :no_phone => true do
    it 'Verify "VOTING IN PROGRESS" section with correct text is displayed.' do
      within ('.state-instructions-sharing-section') do
        page.should have_content ('Voting In Progress')
        page.should have_content ("Select the styles you want us to sell. Leave feedback for the designer, too! The more votes it gets, the more likely it'll get picked!")
      end
    end

    it 'Verify voting hours left displayed. - PENDING' do
    end

    it "Verify user see Details section with correct text" do
      within('.details-section') do
        page.should have_content('Details')
        page.should have_content "It's your chance to be a trendsetter! Does this dress have the right cut, color, and style? Do you think it should be produced and sold on ModCloth? You're the best critic, so vote now!"
      end
    end

    it "Verify user see Sign in comment button if user is not logged in." do
      #page.should have_xpath("//div[@class = 'new-comment']/a[@href = '/be-the-buyer/sign_in']")
      page.find(:xpath, "//div[@class = 'new-comment']/a[@href = '/be-the-buyer/sign_in']", :visible => true).text.should == 'Sign In to Comment'
    end

    it "Verify when sample has atleast 1 comment then user see 'View x all comments' link", :no_phone => true do
      commentable_name = $sample_name
      expected_comment_count = get_comment_count(commentable_name)
      if (expected_comment_count.to_i > 0)
        page.find(:xpath, "//a[@href = '#comments']", :visible => true).text.should == "View All " +expected_comment_count+ " Comments"
        within ('.new-comment') do
          page.should have_link "View All " +expected_comment_count+ " Comments"
        end
      end
    end
  end

  context 'C. Sample detail box' do
    it '1. Verify sample name is displaying correctly' do
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div/div[@class='sample']/div[@class='name']", :visible => true).text.should == expected_sample_name
    end

    it '2. Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div/div[@class='sample']/div[@class = 'pin']", :visible => true)
    end

    it '3. Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div/div[@class='sample']/div[@class = 'price']", :visible => true).text.should == expected_sample_price
    end

    it '4. Verify all the samples on this page have "Pick","Skip" buttons.' do
      page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible =>true).text.should == "SKIP"
      page.find(:xpath, "//div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']", :visible =>true).text.should == "PICK"
    end
  end

  context 'D. Right side widget', :no_phone => true do
    it '1. Verify sample displays Vote count' do
      expected_vote_count = $vote_count

      actual = page.find(:xpath, "//aside/div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
      actual_vote_count = actual.gsub(",", "")
      actual_vote_count.should == expected_vote_count
    end

    it '2. Verify sample displays comment count' do
      commentable_name = $sample_name
      expected_comment_count = get_comment_count(commentable_name)
      page.find(:xpath, "//aside/div[@data-product-id="+First_Voting_SDP_sample_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']", :visible =>true).text.should == expected_comment_count
    end

    it '3. Verify user see message "More Samples - Keep Voting!"' do
      page.find(:xpath, "//div[@class = 'vote-more engagement-widget']", :visible => true).text.should == "More Samples - Keep Voting!"
    end
  end

  context 'E. Pick or skip functionality' do
    it '1. Verify user successfully Sign in and after successful sign in user navigates back to SDP page.' do
      expected_url = current_url
      join()
      current_url.should == expected_url
      go_to_voting_in_progress_page
    end

    it '2. Verify if a logged in user clicks on "Pick" then
        - button changes to "Picked,
        - Pick violater displays on sample image.
        - voting count increments by 1.' do
      go_to_voting_in_progress_page
      No_pick_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s

      if (No_pick_product_id != "")
        go_to_SDP_page(No_pick_product_id)
        if ($device_name != :phone)
          before_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+No_pick_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
          before_vote_count = before_vote_count1.gsub(",", "")
        end

        page.find(:xpath, "//div[@data-product-id="+No_pick_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']", :visible => true).click
        wait_for_script
        visit(current_path)
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+No_pick_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick picked']", :visible => true).text.should == "PICKED"
          page.find(:xpath, "//div[@data-product-id="+No_pick_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).text.should == "SKIP"
          page.should have_xpath("//div[@data-product-id="+No_pick_product_id+"]/div/div[@class='sample']/div[@class='violator picked']", :visible => true)
        }
        if ($device_name != :phone)
          after_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+No_pick_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
          after_vote_count = after_vote_count1.gsub(",", "")
          after_vote_count.to_i.should == before_vote_count.to_i + 1
        end

      else
        fail "No sample found to pick..so This test case is not executed."
      end
    end

    it '3. Verify user can post comment on a sample which he has picked.' do
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      commentable_name = page.find(:xpath, "//div[@class = 'sdp']/div[@class = 'sample']/div[@class = 'name']").text
      before_comments_count = get_comment_count(commentable_name)
      page.find(:xpath, "//div[@class = 'new-comment']", :visible => true)
      within('.new-comment') do
        fill_in 'new-comment-text', :with => 'Great Dress'
        click_button('Comment')
        wait_for_script
      end
      visit(current_path)
      wait_for_script
      page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true)
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      after_comments_count = get_comment_count(commentable_name)
      after_comments_count.to_i.should == before_comments_count.to_i + 1
    end

    it '4. Verify if a logged in user clicks on "Skip" then
        - button changes to "Skipped,
        - Skip violater displays on sample image.
        - voting count increments by 1.' do
      go_to_voting_in_progress_page
      wait_for_script
      No_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (No_skip_product_id != "")
        go_to_SDP_page(No_skip_product_id)
        if ($device_name != :phone)
          before_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+No_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
          before_vote_count = before_vote_count1.gsub(",", "")
        end
        page.find(:xpath, "//div[@data-product-id="+No_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).click
        wait_for_script

        visit(current_path)
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+No_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']", :visible => true).text.should == "PICK"
          page.find(:xpath, "//div[@data-product-id="+No_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip skipped']", :visible => true).text.should == "SKIPPED"
          page.should have_xpath("//div[@data-product-id="+No_skip_product_id+"]/div/div[@class='sample']/div[@class='violator skipped']", :visible => true)
        }
        if ($device_name != :phone)
          after_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+No_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
          after_vote_count = after_vote_count1.gsub(",", "")
          after_vote_count.to_i.should == before_vote_count.to_i + 1
        end
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end

    it '5. Verify user can post comment on a sample which he has skipped.' do
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      commentable_name = page.find(:xpath, "//div[@class = 'sdp']/div[@class = 'sample']/div[@class = 'name']", :visible => true).text
      before_comments_count = get_comment_count(commentable_name)
      page.find(:xpath, "//div[@class = 'new-comment']", :visible => true)
      within('.new-comment') do
        fill_in 'new-comment-text', :with => 'Great Dress'
        click_button('Comment')
        wait_for_script
      end
      visit(current_path)
      wait_for_script
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2", :visible => true).click
      end
      after_comments_count = get_comment_count(commentable_name)
      after_comments_count.to_i.should == before_comments_count.to_i + 1
    end

    it '6. Verify after user changes the vote, vote count remains unchangeed.', :no_phone => true do
      go_to_voting_in_progress_page
      wait_for_script

      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")

        go_to_SDP_page(picked_product_id)
        wait_for_script
        before_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        puts "vote count: #{before_vote_count}"
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).click
        wait_for_script

        visit(current_path)
        wait_for_script
        after_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        after_vote_count.to_i.should == before_vote_count.to_i
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']", :visible => true).click
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end
  end

  context 'F. Arrows' do
    it "1. Verify when user is on 1st sample SDP page then user see only 'Next' arrow." do
      go_to_voting_in_progress_page
      wait_for_script
      go_to_SDP_page(First_Voting_SDP_sample_product_id)
      page.find(:xpath, "//a[@class ='invisible prev']")
      page.find(:xpath, "//a[@class = 'next']", :visible => true)
    end

    it "2. Verify when user is on last sample SDP page then user see only 'Prev' arrow." do
      go_to_voting_in_progress_page
      if ($device_name == :phone)
        sample_count = get_voting_in_progress_SampleCount
        if ($device_name == :phone)
          if (sample_count.to_i > 10)
            page.find(:xpath, "//a[@class = 'next_page']", :visible).click
          end
        end
      end
      last_sample_product_id = page.evaluate_script("$('.sample-data:last').attr('data-product-id')").to_s
      go_to_SDP_page(last_sample_product_id)
      page.find(:xpath, "//a[@class = 'prev']", :visible =>true)
      page.find(:xpath, "//a[@class = 'invisible next']")
    end

    it "3. Verify when user is NOT on 1st or last sample then user see both arrows." do
      go_to_voting_in_progress_page
      second_sample_product_id = page.evaluate_script("$('.sample-data').eq(1).attr('data-product-id')").to_s
      go_to_SDP_page(second_sample_product_id)
      page.find(:xpath, "//a[@class = 'prev']", :visible => true)
      page.find(:xpath, "//a[@class = 'next']", :visible => true)
    end
  end

  context "G. Sign out functionality" do
    it '1. Verify when user clicks on "Sign out" link then user successfully signed out' do
      sign_out
    end
  end

  context "Logged out user functionality" do
    it '1. Go to 1st sample detail page' do
      register_user
      go_to_voting_in_progress_page
      wait_for_script
      go_to_SDP_page(First_Voting_SDP_sample_product_id)
    end

    it '2. Verify after clicking on "Sign in Comment" button and successful login user navigates back to SDP page.' do
      expected_url = current_url
      page.find(:xpath, "//div[@class = 'new-comment']/a", :visible => true).click
      wait_for_script
      sign_in()
      wait_for_script
      actual_url = current_url
      expected_url.should == actual_url
    end

    it "3 Verify user see 'Write a comment' text." do
      page.find(:xpath, "//div[@class = 'new-comment']", :visible => true)
      within('.new-comment .new-comment-header') do
        page.should have_content ('Write a Comment')
      end
      page.find(:xpath, "//textarea[@name = 'new-comment-text' and @placeholder = 'Write a comment...']", :visible =>true)
      sign_out()
    end

    it 'BUGGG 5. Verify when user click on "Pick" button, Log in window gets displayed and upon successful login following operations happens -
            - button changes to "Picked,
            - Pick violater displays on sample image.
            - voting count increments by 1.' do
      go_to_voting_in_progress_page
      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      if ($device_name != :phone)
        before_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+first_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
      end

      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']", :visible => true).click
      sign_in()
      wait_for_script
      visit(current_path)
      wait_until {
        page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick picked']", :visible => true).text.should == "PICKED"
        page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).text.should == "SKIP"
        page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div[@class='violator picked']", :visible => true)
      }
      if ($device_name != :phone)
        after_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+first_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      end
      sign_out
    end

    it ' BUGG 6. Verify when user click on "Skip" button, Log in window gets displayed and upon successful login following operations happens -
                  - button changes to "Skipped,
                  - Skip violater displays on sample image.
                  - voting count increments by 1.' do
      go_to_voting_in_progress_page
      second_sample_product_id = page.evaluate_script("$('.sample-data').eq(1).attr('data-product-id')").to_s
      if ($device_name != :phone)
        go_to_SDP_page(second_sample_product_id)
        before_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+second_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        before_vote_count = before_vote_count1.gsub(",", "")
      end
      page.find(:xpath, "//div[@data-product-id="+second_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).click
      sign_in()
      wait_for_script
      visit(current_path)
      wait_until {
        page.find(:xpath, "//div[@data-product-id="+second_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick picked']", :visible => true).text.should == "PICKED"
        page.find(:xpath, "//div[@data-product-id="+second_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']", :visible => true).text.should == "SKIP"
        page.find(:xpath, "//div[@data-product-id="+second_sample_product_id+"]/div/div[@class='sample']/div[@class='violator picked']", :visible => true)
      }
      if ($device_name != :phone)
        after_vote_count1 = page.find(:xpath, "//aside/div[@data-product-id="+second_sample_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']", :visible => true).text
        after_vote_count = after_vote_count1.gsub(",", "")
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      end
    end
  end
end