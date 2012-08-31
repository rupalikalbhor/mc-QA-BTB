require 'spec/support/shared_example_BTB'
require 'spec/support/common_helper'

describe 'Awaiting Results page' do

  let(:path) { 'awaiting-results' }
  let(:page_title) { 'Awaiting Results' }

  before(:all) do
    go_to_BTB_page
    wait_for_script
  end

  it 'Verify "Awaiting Results" link is loads correct url and title.' do
    expected_path = current_url + path
    page.find(:xpath, "//a[@href='/be-the-buyer/awaiting-results']/li/[contains(text(),'Awaiting Results')]").click
    page.driver.browser.navigate.refresh

    page.current_url.should == expected_path
    page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title awaiting-results']").text.should == page_title
  end

  it 'Verify pagination displays correctly' do
    sample_count = page.body.match(/of (\d+)/)[1]
    page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+sample_count+ ' of ' + sample_count
  end

  it 'Verify user sees "Your Samples" section with correct title' do
    page.find(:xpath, "//div[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
  end

  it 'Verify breadcrumb displays correct sequence with text' do
    page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Awaiting Results'
  end

  it 'Verify clicking on breadcrumb links load relevant pages.' do
    page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]").click
    go_to_awaiting_results_page
    page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]").click
    go_to_awaiting_results_page
  end

  context 'Sample Box' do
    it '1. Verify sample number is displaying correctly' do
      page.find(:xpath, "//div[@class = 'name']").text.should match /Sample [0-9]+/

      FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
      get_voting_in_progress_SampleDetails(FIRST_SAMPLE_PRODUCT_ID)
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='name']").text.should == expected_sample_name
    end

    it 'Verify pin icon is displaying in sample box' do
      page.should have_xpath("//div[@class = 'pin']")
    end


    it 'Verify correct dollar amount appears above each sample' do
      page.find(:xpath, "//div[@class = 'price']").text.should match /[$][0-9]+[.][0-9]+/
    end

    it 'Verify all the samples on this page have "Pick" and "Skip" buttons.' do
      page.find(:xpath, "//a[@class = 'pick']").text.should == "Pick"
      page.find(:xpath, "//a[@class = 'skip']").text.should == "Skip"

    end

    it 'Verify sample displays Vote count' do
      page.find(:xpath, "//div[@class = 'vote-count']").text.should == "2"
    end

    it 'Verify sample displays comment count' do
      page.find(:xpath, "//div[@class = 'comments-count']").text.should match /[0-9]+/
    end

    it 'Verify sample displays "Voting End date" with clock icon.' do
      page.find(:xpath, "//div[@class = 'time-remaining']").text.should == "10h"
    end

    it 'Verify when user clicks on sample image then user navigates to SDP' do

    end
  end
end

def go_to_awaiting_results_page
  go_to_BTB_page
  page.find(:xpath, "//a[@href='/be-the-buyer/awaiting-results']/li/div[contains(text(),'Awaiting Results')]").click
  page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title awaiting-results']").text.should == 'Awaiting Results'
end