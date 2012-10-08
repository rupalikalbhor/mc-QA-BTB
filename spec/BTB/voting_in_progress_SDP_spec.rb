# encoding: utf-8
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'SDP - Voting In Progress' do
  let(:page_title) { 'Voting In Progress' }
    expected_sample_count = get_voting_in_progress_SampleCount

    before(:all) do
      go_to_BTB_page
      wait_for_script
    end

  it '1. Get first sample from grid' do
    go_to_voting_in_progress_page
    wait_for_script
    FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
    get_voting_in_progress_SampleDetails(FIRST_SAMPLE_PRODUCT_ID) #Get sample details from database
  end

  it '2. Verify when user clicks on sample image then user navigates to SDP' do
    sample_number = $sample_name.gsub("Sample ", '')
    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']").click
    wait_until {
      page.should have_xpath("//div[@class='sdp']")
    }
  end

  context 'A. Breadcrumb' do
    it 'Verify breadcrumb displays in this format ModCloth » Be The Buyer » Voting In Progress » <Selected sample number>' do
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress » '+$sample_name
    end
  end

  context 'B. Left side section' do
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

    it "Verify user see 'Write a comment' text." do
      within('.new-comment .new-comment-header') do
        page.should have_content ('Write a Comment')
      end
      page.find(:xpath, "//textarea[@name = 'new-comment-text' and @placeholder = 'Write a comment...']")
    end

    it "Verify when sample has atleast 1 comment then user see 'View x all comments' link" do
      commentable_name = $sample_name
      expected_comment_count = get_voting_in_progress_CommentCount(commentable_name)
      if (expected_comment_count.to_i > 0)
        page.find(:xpath, "//a[@href = '#comments']").text.should == "View All " +expected_comment_count+ " Comments"
        within ('.new-comment') do
          page.should have_link "View All " +expected_comment_count+ " Comments"
        end
      end
    end
  end

  context 'Sample detail box' do
    it 'Verify sample image displays correctly.' do

    end

    it '3. Verify sample name is displaying correctly' do
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class='sample']/div[@class='name']").text.should == expected_sample_name
    end

    it '4. Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class='sample']/div[@class = 'pin']")
    end

    it '5. Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class='sample']/div[@class = 'price']").text.should == expected_sample_price
    end

    it '6. Verify all the samples on this page have "Pick","Skip" buttons.' do
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class='sample']/div/a[@class = 'skip']").text.should == "SKIP"
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class='sample']/div/a[@class = 'pick']").text.should == "PICK"
    end
  end

  context 'Right side widget' do
    it '1. Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      page.find(:xpath, "//aside/div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text.should == expected_vote_count
    end

    it '2. Verify sample displays comment count' do
      commentable_name = $sample_name
      expected_comment_count = get_voting_in_progress_CommentCount(commentable_name)
      page.find(:xpath, "//aside/div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='counter'][2]/div[@class = 'comment-count']").text.should == expected_comment_count
    end

    it '3. Verify user see message "More Samples - Keep Voting!"' do
      page.find(:xpath, "//div[@class = 'vote-more engagement-widget']").text.should == "More Samples - Keep Voting!"
    end
  end

  context 'Pick or skip functionality' do
    it '1. Verify user successfully Sign in' do
      sign_in
      wait_for_script
    end

    it '2. Verify if a logged in user clicks on "Pick" then
        - button changes to "Picked,
        - Pick violater displays on sample image.
        - voting count increments by 1.' do
      go_to_voting_in_progress_page
      wait_for_script
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s

      if (no_pick_no_skip_product_id != "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class = 'photo']/a").click
        wait_until {
          page.should have_xpath("//div[@class='sdp']")
        }
        before_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']").click
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick picked']").text.should == "PICKED"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']").text.should == "SKIP"
          page.should have_xpath("//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div[@class='violator picked']")
        }
        after_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to pick..so This test case is not executed."
      end
    end

    it '4. Verify if a logged in user clicks on "Skip" then voting count increments by 1.' do
      go_to_voting_in_progress_page
      wait_for_script
      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class = 'photo']/a").click
        wait_until {
          page.should have_xpath("//div[@class='sdp']")
        }
        before_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']").click
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_until {
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']").text.should == "PICK"
          page.find(:xpath, "//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip skipped']").text.should == "SKIPPED"
          page.should have_xpath("//div[@data-product-id="+no_pick_no_skip_product_id+"]/div/div[@class='sample']/div[@class='violator skipped']")
        }
        after_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+no_pick_no_skip_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i + 1
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end

    it '5. Verify user can post comment on a sample which he has picked.' do
      go_to_voting_in_progress_page
      wait_for_script
      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a").click
        wait_until {
          page.should have_xpath("//div[@class='sdp']")
        }
        wait_for_script
        before_comments_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']").text
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
          wait_for_script
        end
        page.driver.browser.navigate.refresh
        wait_for_script
        after_comments_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']").text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '6. Verify user can post comment on a sample which he has skipped.' do
      go_to_voting_in_progress_page
      wait_for_script

      skipped_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix skipped\"]").eq(0).parent().attr("data-product-id")').to_s
      if (skipped_product_id != "")
        page.find(:xpath, "//div[@data-product-id="+skipped_product_id+"]/div[@class = 'photo']/a").click
        wait_until {
          page.should have_xpath("//div[@class='sdp']")
        }
        wait_for_script
        before_comments_count = page.find(:xpath, "//aside/div[@data-product-id="+skipped_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']").text
        within('.new-comment') do
          fill_in 'new-comment-text', :with => 'Great Dress'
          click_button('Comment')
          wait_for_script
        end
        page.driver.browser.navigate.refresh
        wait_for_script
        after_comments_count = page.find(:xpath, "//aside/div[@data-product-id="+skipped_product_id+"]/div[@class='counter'][2]/div[@class = 'comment-count']").text
        after_comments_count.to_i.should == before_comments_count.to_i + 1
      else
        fail "No picked sample found..so This test case is not executed."
      end
    end

    it '7. Verify after user changes the vote, vote count remains unchangeed.' do
      go_to_voting_in_progress_page
      wait_for_script

      picked_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix picked\"]").eq(0).parent().attr("data-product-id")').to_s
      if (picked_product_id != "")
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div[@class = 'photo']/a").click
        wait_until {
          page.should have_xpath("//div[@class='sdp']")
        }
        wait_for_script
        before_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']").click
        wait_for_script
        page.driver.browser.navigate.refresh
        wait_for_script
        after_vote_count = page.find(:xpath, "//aside/div[@data-product-id="+picked_product_id+"]/div[@class='counter'][1]/div[@class = 'vote-count']").text
        after_vote_count.to_i.should == before_vote_count.to_i
        page.find(:xpath, "//div[@data-product-id="+picked_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']").click
      else
        fail "No sample found to skip..so This test case is not executed."
      end
    end

    context "E. Sign out functionality" do
      it '1. Verify when user clicks on "Sign out" link then user successfully signed out' do
        wait_for_script
        sign_out
      end
    end
  end


  context 'Arrows' do
    it "Verify when user is on 1st sample SDP page then user see only 'Next' arrow." do
      go_to_voting_in_progress_page
      sample_number = $sample_name.gsub("Sample ", '')
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']").click
      wait_until {
        page.should have_xpath("//div[@class='sdp']")
      }
      page.should have_xpath("//a[@class ='invisible prev']")
      page.should have_xpath("//a[@class = 'next']")
    end
    it "Verify when user is on last sample SDP page then user see only 'Prev' arrow." do
      go_to_voting_in_progress_page
      last_sample_product_id = page.evaluate_script("$('.sample-data:last').attr('data-product-id')").to_s
      page.find(:xpath, "//div[@data-product-id="+last_sample_product_id+"]/div[@class = 'photo']/a").click
      wait_until {
        page.should have_xpath("//div[@class = 'sdp']")
      }
      page.should have_xpath("//a[@class = 'prev']")
      page.should have_xpath("//a[@class = 'invisible next']")
    end

    it "Verify when user is NOT on 1st or last sample then user see both arrows." do
      go_to_voting_in_progress_page
      second_sample_product_id = page.evaluate_script("$('.sample-data').eq(1).attr('data-product-id')").to_s
      page.find(:xpath, "//div[@data-product-id="+second_sample_product_id +"]/div[@class = 'photo']/a").click
      wait_until {
        page.should have_xpath("//div[@class='sdp']")
      }
      page.should have_xpath("//a[@class = 'prev']")
      page.should have_xpath("//a[@class = 'next']")
    end
  end


  it '9. Verify sample displays "Voting End date" with clock icon.' do
  end
end
