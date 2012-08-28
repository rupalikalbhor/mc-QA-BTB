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
    page.find(:xpath, "//a[@href='awaiting-results']/li/div[text()='Awaiting Results']").click
    page.driver.browser.navigate.refresh

    page.current_url.should == expected_path
    page.find(:xpath, "//div[@class='awaiting-results div nav title']").text.should == page_title
  end

  it 'Verify pagination displays correctly' do
    sample_count = page.body.match(/of (\d+)/)[1]
    page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+sample_count+ ' of ' + sample_count
  end

  it 'Verify user sees "Your Samples" section with correct title' do
    page.find(:xpath, "//div[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
  end

  it 'Verify breadcrumb displays correct sequence with text' do

  end

  it 'Verify clicking on breadcrumb links load relevant pages.' do

  end

  context 'Sample Box' do
    it 'Verify correct sample is displaying' do

    end

    it 'Verify sample number is displaying correctly' do
      page.find(:xpath, "//div[@class = 'name']").text.should match /Sample [0-9]+/
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