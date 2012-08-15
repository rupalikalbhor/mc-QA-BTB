require 'support/common_helper'
require 'support/query_helper'

describe 'Posting comment on a sample for a logged-in user' do
  before(:all) do
    go_to_BTB_page
    sign_in
    wait_for_script
    go_to_SDP
  end

  context "I. UI"
  it '1. Verify the text "Comments" is visible above the comments text-box', :type => :request do
    within ('#comment-view') do
      page.should have_content ("Comments")
    end
  end

  it '2. Verify the comment text-box is visible' do
    within ('#comment-view .new-comment') do
      page.find(:xpath, "//textarea[@name='new-comment-text']").visible?.should eq(true)
    end
  end

  it '3. Verify when user clicks inside the text-box, the "Comment" button is visible and still disabled' do
    within ('#comment-view .new-comment') do
      page.find(:xpath, "//textarea[@name='new-comment-text']").click
      page.find(:xpath, "//input[@type='submit']").visible?.should eq (true)
      page.find(:xpath, "//input[@type='submit']")['disabled'].should eq("true")
    end
  end

  it '4. Verify when user clicks inside the text-box, the tooltip becomes visible with valid text' do
    find(:xpath, "//textarea[@name='new-comment-text']").click
    within ('#comment-view .new-comment') do
      find(:xpath, "//span[@style='display: block;']").text.should eq('Be polite! Is your comment constructive?')
      page.should have_content('Be polite! Is your comment constructive?')
    end
  end

  it '5. Verify after user types at least one character, the comment button gets enabled' do
    within ('#comment-view .new-comment') do
      page.find(:xpath, "//textarea[@name='new-comment-text']").click
      fill_in 'new-comment-text', :with => 'A'
      page.find("input[@type='submit']").visible?.should eq (true)
      page.find("input[@type='submit']")['disabled'].should eq(nil)
    end
  end

  context "II. No voting"
  it '1. Verify user is able to submit a valid comment' do
    within ('#comment-view .new-comment') do
      page.find(:xpath, "//textarea[@name='new-comment-text']").click
      @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
      @@comment = 'New comment is added by QA ' +@currentDateTime.to_s #@@comment is a class variable.
      fill_in 'new-comment-text', :with => @@comment
      page.find("input[@type='submit']").click
      page.find(:xpath, "//div[@class = 'comments all']/div/div").text.should eq(@@comment)
    end
  end

  it '2. Verify after page refresh the comment is retained and comment count increments by 1' do
    expected_comment_count = page.body.match(/of (\d+)/)[1]
    page.driver.browser.navigate.refresh
    page.find(:xpath, "//div[@class = 'comments all']/div/div").text.should eq(@@comment)
    actual_comment_count = (page.body.match(/of (\d+)/)[1])
    actual_comment_count.to_i.should eq(expected_comment_count.to_i + 1)
  end

  it '3. Verify top pagination matches bottom comment pagination' do
    page.find(:xpath, "//p[@class = 'comment-results']").text.should eq(page.find(:xpath, "(//p[@class = 'comment-results'])[2]").text)
  end

  it '4. Verify user does not see "Agree" link on her own comment' do
    page.should_not have_xpath("//div[@data-comment-id=#{$comment_id}]/div/span/a[text() = 'Agree']")
  end

  it '5. Verify user does not see "Reply" link on her own comment' do
    page.should_not have_xpath("//div[@data-comment-id=#{$comment_id}]/div/span/a[text() = 'Reply']")
  end

  it '6. Verify user should not see "Flag" button on her own comment' do
    page.should_not have_xpath("//div[@data-comment-id=#{$comment_id}]/div/span/div/a[text() = 'Flag']")
  end

  it '7. Verify user is able to submit a comment with long text and comment does not get truncated on front end' do
      within ('#comment-view .new-comment') do
        page.find(:xpath, "//textarea[@name='new-comment-text']").click
        @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
        @@comment = 'New comment is added by QA1' +@currentDateTime.to_s+ 'New comment is added by QA2, New comment is added by QA3, New comment is added by QA4, New comment is added by QA5, New comment is added by QA6, New comment is added by QA7, New comment is added by QA8, New comment is added by QA9, New comment is added by QA10, New comment is added by QA11, New comment is added by QA12, New comment is added by QA13, New comment is added by QA14, New comment is added by QA15, New comment is added by QA16, New comment is added by QA17, New comment is added by QA18, New comment is added by QA19, New comment is added by QA20'
        fill_in 'new-comment-text', :with => @@comment
        page.find("input[@type='submit']").click
        page.find(:xpath, "//div[@class = 'comments all']/div/div").text.should eq(@@comment)
      end
    end

  #it '7. Verify user should see her name next to her own comment' do
  #  puts "First name is ,,,,, #{$first_name}"
  #  page.find(:xpath, "//div[@class = 'comments all']/div/div").text.should eq(@@comment)
  #
  #
  #  within ('.comment .content') do
  #    page.should have_content(@@comment)
  #    puts page.find('.commenter').text
  #  end

    #page.should have_xpath("//div[@class = 'commenter' and text()='firstname123456...']")
    #within (page.find(:xpath, "//div[@data-comment-id=#{$comment_id}]"))do
    #  puts page.find("//div[@class = 'commenter']").text
    #end


    #page.find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/div").text.should eq('firstname123456...')
    #page.find(:xpath, "//div[@data-comment-id=#{$comment_id}]/div/div").text.should eq($first_name)


    #page.should_not have_xpath("//div[@data-comment-id=#{$comment_id}]/div/span/span/a[text() = 'Reply']")
    #puts "User name is **: #{page.find(:xpath, "//div[@class = 'commenter']").text}"
  #end

  #it '7. Verify user should see time of post on her own comment' do
  #end

  #it '8. Verify the voting status appears as blank' do
  #end

  #context "Pick"
  #it '1. Verify user is able to submit a valid comment by selecting vote as "Pick"' do
  #end
  #
  #it '2. Verify the voting status appears as "Picked"' do
  #end
  #
  #context "Skip"
  #it '1. Verify user is able to submit a valid comment by selecting vote as "Skip"' do
  #end
  #
  #it '2. Verify the voting status appears as "Skipped"' do
  #end
  #
  #context "Blocked words"
  #it '1. Verify when user enters a comment with blocked word and refresh the page, the comment disappears from the page' do
  #end

  context "Invalid"
  it '1. Verify when user enters more than 1000 characters, warning message appears and "Comment" button disappears' do
    within ('#comment-view .new-comment') do
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

  after(:all) do
      delete_comment
    end
  #describe "Not logged in user"

end