# encoding: utf-8
require 'spec/support/shared_example_BTB'
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'voting in progress page' do
  let(:page_title) { 'Voting In Progress' }
  expected_sample_count = get_voting_in_progress_SampleCount

  before(:all) do
    go_to_BTB_page
    wait_for_script
  end

  context "UI" do
    it '1. Verify "Voting In Progress" link is loading correct url and title.' do
      expected_path = current_url
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
      page.driver.browser.navigate.refresh
      page.current_url.should == expected_path
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == page_title
    end

    it '2. Verify pagination displays correctly' do
      page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
    end

    it '3. Verify user sees "Your Sample" section with correct title' do
      page.find(:xpath, "//div[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
    end

    it '4. Verify breadcrumb displays correct sequence with text' do
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress'
    end

    it '5. Verify clicking on breadcrumb links load relevant pages.' do
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]").click
      go_to_voting_in_progress_page
      page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]").click
      go_to_voting_in_progress_page
    end
  end


  context 'Sample Box' do
    it '1. Verify sample number is displaying correctly' do
      FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
      get_voting_in_progress_SampleDetails(FIRST_SAMPLE_PRODUCT_ID)
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

    it '4. Verify all the samples on this page have "Pick","Skip" or "Picked", "Skipped" buttons.' do
      page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
      voting_status = page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix picked']/a").text
      if (voting_status == "PICKED")
        page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix picked']/a[@class = 'skip']").text.should == "SKIP"
      else
        if (voting_status == "SKIPPED")
          page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix picked']/a[@class = 'skip']").text.should == "PICK"
        else
          page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix picked']/a[@class = 'skip']").text.should == "SKIP"
          page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'voting-and-notification clearfix picked']/a[@class = 'skip']").text.should == "PICK"
        end
      end
    end

    it '5. Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'vote-count']").text.should == expected_vote_count
    end

    it '6. Verify sample displays comment count' do
      commentable_name = $sample_name.gsub("Sample ",'')
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
      page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress » '+$sample_name
    end
  end

  context "Pick or Skip functionality" do
    it '' do

    end

  end
end

def get_voting_date_time(expected_voting_time)
  strlength = expected_voting_time.length
  days = expected_voting_time[0, 1]+"d"+" "

  if (strlength > 8)
    hours = expected_voting_time[6, 2]
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
  page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
  page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == 'Voting In Progress'
end
