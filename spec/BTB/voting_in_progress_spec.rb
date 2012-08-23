require 'spec/support/shared_example_BTB'
require 'spec/support/common_helper'

describe 'voting in progress page' do

  let(:path) { 'in-progress' }
  let(:page_title) { 'Voting In Progress' }

  before(:all) do
    go_to_BTB_page
    wait_for_script
  end

  it 'Verify "Voting In Progress" link is loading correct url and title.' do
    expected_path = current_url + path
    page.find(:xpath, "//div[@class='title']").click
    page.driver.browser.navigate.refresh

    page.current_url.should == expected_path
    page.find(:xpath, "//div[@class='in-progress title']").text.should == page_title
  end

  it 'Verify pagination displays correctly' do
    sample_count = page.body.match(/of (\d+)/)[1]
    page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+sample_count+ ' of ' + sample_count
  end

  it 'Verify user sees "Your Sample" section with correct title' do
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
      page.find(:xpath, "//div[@class = 'name']").text.should == "Sample 2133"
    end

    it 'Verify pin icon is displaying in sample box' do
      page.should have_xpath("//div[@class = 'pin']")
    end

    it 'Verify correct dollar amount appears above each sample' do
      page.find(:xpath, "//div[@class = 'price']").text.should == "$22.22"
    end

    it 'Verify all the samples on this page have "Pick" and "Skip" buttons.' do
      page.find(:xpath, "//a[@class = 'pick']").text.should == "Pick"
      page.find(:xpath, "//a[@class = 'skip']").text.should == "Skip"

    end

    it 'Verify sample displays Vote count' do
      page.find(:xpath, "//div[@class = 'vote-count']").text.should == "2"
    end

    it 'Verify sample displays comment count' do
      page.find(:xpath, "//div[@class = 'comments-count']").text.should == "0"
    end

    it 'Verify sample displays "Voting End date" with clock icon.' do
      page.find(:xpath, "//div[@class = 'time-remaining']").text.should == "10h"
    end

    it 'Verify when user clicks on sample image then user navigates to SDP' do

    end
  end


  #it 'is accessible' do
  #  visit root_path
  #  click_link page_title
  #  page.current_path.should == path
  #end
  #
  #it 'has breadcrumbs' do
  #  page.find('#breadcrumbs').should satisfy do |breadcrumb|
  #    breadcrumb.find('a:first').text.should == 'ModCloth'
  #    breadcrumb.find('a:first')['href'].should =~ /modcloth\.com/
  #
  #    breadcrumb.find('a:last').text.should == 'Be The Buyer'
  #    breadcrumb.find('a:last')['href'].should == root_path
  #
  #    breadcrumb.text.should include page_title
  #  end
  #end
  #
  #context 'displays navigation bar' do
  #  subject { page.find('.navigation')}
  #
  #  it 'includes the title' do
  #    subject.find('.title').should have_content page_title
  #  end
  #
  #  it "includes pagination summary" do
  #    subject.find('.pagination').should have_content "Showing 1 - 1 of 1"
  #  end
  #
  #end
  #
  #context 'displays sample box', js: true do
  #  subject { page.find("div[data-product-id='#{sample.id}']") }
  #
  #  it_behaves_like 'a grid-view sample'
  #
  #  it 'includes voting buttons' do
  #    subject.should have_link "Pick"
  #    subject.should have_link "Skip"
  #  end
  #
  #  it 'includes time left' do
  #    subject.find('.time-remaining').should have_content "6d 23h"
  #  end
  #end
end