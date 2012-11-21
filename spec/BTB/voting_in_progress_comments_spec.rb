# encoding: utf-8
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'Posting comment on a sample for logged-in user' do
  before(:all) do
    go_to_BTB_page
    wait_for_script
    click_sign_in_link()
    sign_in()
    wait_for_script
    go_to_voting_in_progress_page
  end

  context "I. UI" do
    it '1. Go to first sample SDP page.' do
      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      wait_for_script
      get_voting_in_progress_SampleDetails(first_sample_product_id) #Get sample details from database
    end

    it "2. Verify user see 'Write a comment' text above the comments text-box." do
      within('.new-comment .new-comment-header') do
        page.should have_content ('Write a Comment')
      end
    end

    it '3. Verify the comment text-box is visible' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").visible?.should eq(true)
      end
    end

    it '4. Verify when user clicks inside the text-box, the "Comment" button is visible and still disabled' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        page.find(:xpath, "//input[@type='submit']").visible?.should eq (true)
        page.should have_xpath ("//input[@disabled = 'disabled']")
      end
    end

    #it '5. Verify when user clicks inside the text-box, the tooltip becomes visible with valid text' do
    #  find(:xpath, "//textarea[@name='new-comment-text']").click
    #  within ('.new-comment') do
    #    find(:xpath, "//span[@style='display: block;']").text.should eq('Be polite! Is your comment constructive?')
    #    page.should have_content('Be polite! Is your comment constructive?')
    #  end
    #end

    it '6. Verify after user types at least one character, the comment button gets enabled' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        fill_in 'new-comment-text', :with => 'Great Dress'
        wait_for_script
        page.find("input[@type='submit']").visible?.should eq (true)
        page.should_not have_xpath("//input[@disabled = 'disabled']")
      end
    end

    it "7. Verify when sample has atleast 1 comment then user see 'View x all comments' link", :no_phone => true do
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

  context "II. No voting" do
    it '1. Go to Sample SDP where user is not voted yet' do
      go_to_voting_in_progress_page
      wait_for_script

      no_pick_no_skip_product_id = page.evaluate_script('$("div[class=\"voting-and-notification clearfix\"]").eq(0).parent().attr("data-product-id")').to_s
      if (no_pick_no_skip_product_id != "")
        go_to_SDP_page(no_pick_no_skip_product_id)
      else
        fail "No sample found to execute these test.."
      end
    end

    it 'New comment' do
      currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
      New_comment = 'New comment is added by QA ' +currentDateTime.to_s
      New_comment_id = page.evaluate_script("$('div[class="+"content"+"]').text('Greate Dress').eq(0).parent().attr('data-comment-id')").to_s
    end

    it '2. Verify user is able to submit a valid comment' do
      puts "New comment is: #{New_comment}"
      puts "New comment id is: #{New_comment_id}"
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        fill_in 'new-comment-text', :with => New_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh #Need to delete this line after bug gets fixed
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(New_comment)
      end
    end

    it '3. Verify the voting status appears as blank' do
      page.find(:xpath, "//div[@data-comment-id = "+New_comment_id+"]/div[@class = 'vote']").text.should == ""
    end
  end

  context "II. Write a comment" do
    it '1. Go to 1st sample' do
      go_to_voting_in_progress_page
      wait_for_script
      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s

      if (first_sample_product_id != "")
        go_to_SDP_page(first_sample_product_id)
      else
        fail "No sample found to execute these test.."
      end
    end

    it '2. Verify user is able to submit a valid comment - BUGGGG' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        fill_in 'new-comment-text', :with => New_comment
        page.find("input[@type='submit']").click
        #page.driver.browser.navigate.refresh #Need to delete this line after bug gets fixed
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end

        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(New_comment)
      end
    end

    it '3. Verify after page refresh the comment is retained and comment count increments by 1' do
      #expected_comment_count = page.evaluate_script("$('.comment-list ul li').size()").to_s
      expected_comment_count = page.body.match(/of (\d+)/)[1]
      page.driver.browser.navigate.refresh
      if ($device_name == :phone)
        page.find(:xpath, "//div[@id = 'comment-section']/h2").click
      end
      page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(New_comment)
      #actual_comment_count = page.evaluate_script("$('.comment-list ul li').size()").to_s
      actual_comment_count = page.body.match(/of (\d+)/)[1]
      actual_comment_count.to_i.should eq(expected_comment_count.to_i + 1)
    end

    it '4. Verify user does not see "Agree" link on her own comment' do
      #NEW_COMMENT_ID = page.evaluate_script("$('.comment-list ul li .content:contains("+New_comment+")').parent().attr('data-comment-id')").to_s
      page.should_not have_xpath("//div[@data-comment-id=#{New_comment_id}]/div/span/a[text() = 'Agree']")
    end

    it '5. Verify user does not see "Reply" link on her own comment' do
      page.should_not have_xpath("//div[@data-comment-id=#{New_comment_id}]/div/span/a[text() = 'Reply']")
    end

    it '6. Verify user should not see "Flag" button on her own comment' do
      page.should_not have_xpath("//div[@data-comment-id=#{New_comment_id}]/div/span/div/a[text() = 'Flag']")
    end
    #
    #  it '7. Verify user should see her name next to her own comment' do
    #    name = get_short_name1($first_name)
    #    page.find(:xpath, "//div[@data-comment-id = "+New_comment_id+"]/div[@class = 'commenter']").text.should == name
    #  end
    #
    #  it '8. Verify user should see time of post on her own comment' do
    #    page.find(:xpath, "//div[@data-comment-id = "+New_comment_id+"]/div[@class = 'metadata']/div[@class = 'time']").text.should == "a few seconds ago"
    #  end

    it '9. Verify user is able to submit a comment with long text and comment does not get truncated on front end' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
        Long_comment = 'New comment is added by QA1' +@currentDateTime.to_s+ ' New comment is added by QA2, New comment is added by QA3, New comment is added by QA4, New comment is added by QA5, New comment is added by QA6, New comment is added by QA7, New comment is added by QA8, New comment is added by QA9, New comment is added by QA10, New comment is added by QA11, New comment is added by QA12'
        fill_in 'new-comment-text', :with => Long_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
          page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div/span/a").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(Long_comment)
      end
    end

    it '10. Verify when user enters a comment with blocked word and refresh the page, the comment disappears from the page' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        blocked_word_comment = 'New comment is added by QA for blocked word WALMART'
        fill_in 'new-comment-text', :with => blocked_word_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should_not eq(blocked_word_comment)
      end
    end
  end


  context "IV. Pick" do
    it '1. Verify user is able to submit a valid comment by selecting vote as "Pick"' do
      go_to_voting_in_progress_page
      wait_for_script

      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      wait_for_script
      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'pick']").click
      wait_for_script
      page.driver.browser.navigate.refresh
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
        Pick_comment = 'New comment is added by QA ' +@currentDateTime.to_s
        fill_in 'new-comment-text', :with => Pick_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(Pick_comment)
      end
    end

    it '2. Verify the voting status appears as "Picked"' do
      page.driver.browser.navigate.refresh
      Pick_comment_id = page.evaluate_script("$('.comment-list ul li .content:contains("+Pick_comment+")').parent().attr('data-comment-id')").to_s
      #page.should have_xpath("//div[@data-comment-id = "+Pick_comment_id+"]/div[@class = 'vote pick']")
      page.find(:xpath, "//div[@data-comment-id = "+Pick_comment_id+"]/div[@class = 'vote pick']").text().should == "Picked It"
    end
  end

  context "V. Skip" do
    it '1. Verify user is able to submit a valid comment by selecting vote as "Skip"' do
      go_to_voting_in_progress_page
      wait_for_script

      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      wait_for_script
      page.find(:xpath, "//div[@data-product-id="+first_sample_product_id+"]/div/div[@class='sample']/div/a[@class = 'skip']").click
      wait_for_script
      page.driver.browser.navigate.refresh
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
        Skip_comment = 'New comment is added by QA ' +@currentDateTime.to_s
        fill_in 'new-comment-text', :with => Skip_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(Skip_comment)
      end
    end

    it '2. Verify the voting status appears as "Picked"' do
      page.driver.browser.navigate.refresh
      Skip_comment_id = page.evaluate_script("$('.comment-list ul li .content:contains("+Skip_comment+")').parent().attr('data-comment-id')").to_s
      #page.should have_xpath("//div[@data-comment-id = "+Skip_comment_id+"]/div[@class = 'vote skip']")
      page.find(:xpath, "//div[@data-comment-id = "+Skip_comment_id+"]/div[@class = 'vote skip']").text().should == "Skipped It"
    end
  end

  context "VI. Blocked words" do
    it '1. Verify when user enters a comment with blocked word and refresh the page, the comment disappears from the page' do
      go_to_voting_in_progress_page
      wait_for_script

      first_sample_product_id = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
      go_to_SDP_page(first_sample_product_id)
      wait_for_script

      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        #@currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
        Blocked_comment = 'New comment is added by QA with blocked word Target and Walmart'
        fill_in 'new-comment-text', :with => Blocked_comment
        page.find("input[@type='submit']").click
        page.driver.browser.navigate.refresh
        if ($device_name == :phone)
          page.find(:xpath, "//div[@id = 'comment-section']/h2").click
        end
        page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should_not eq(Blocked_comment)
      end
    end
  end

  context "VII. Invalid" do
    it '1. Verify when user enters more than 1000 characters, warning message appears and "Comment" button disappears' do
      within ('.new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        fill_in 'new-comment-text', :with => 'New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05
          New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05 New comment is added by QA 2012-08-13-16-26-05'
        page.find("input[@type='submit']").visible?.should eq (false)
      end
      page.find(:xpath, "//div[@class = 'post-error']").text.should eq('Please enter in a comment with 10000 characters or less. The comment currently is 10090 characters.')
    end
  end

  #after(:all) do
  #  delete_comment
  #end
  ##describe "Not logged in user"
end





