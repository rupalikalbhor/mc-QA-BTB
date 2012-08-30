require 'spec/support/shared_example_BTB'
require 'spec/support/common_helper'
require 'spec/support/query_helper'

describe 'voting in progress page' do

  let(:path) { 'in-progress' }
  let(:page_title) { 'Voting In Progress' }
  expected_sample_count = get_voting_in_progress_SampleCount


  before(:all) do
    go_to_BTB_page
    wait_for_script
  end

  context "UI" do
    it 'Verify "Voting In Progress" link is loading correct url and title.' do
      expected_path = current_url + path
      page.find(:xpath, "//a[@href='in-progress']/li/div[contains(text(),'Voting In Progress')]").click
      page.driver.browser.navigate.refresh

      page.current_url.should == expected_path
      page.find(:xpath, "//div[@class='div nav page-title voting-in-progress']").text.should == page_title
    end

    it 'Verify pagination displays correctly' do
      page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
    end

    it 'Verify user sees "Your Sample" section with correct title' do
      page.find(:xpath, "//div[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
    end

    it 'Verify breadcrumb displays correct sequence with text' do

    end

    it 'Verify clicking on breadcrumb links load relevant pages.' do

    end
  end


  context 'Sample Box' do
    it 'Verify sample number is displaying correctly' do
      #var = page.find(:xpath, "//div[@class='sample-grid']/div[@class='sample'][2]/div[@data-product-id]").value
      #puts " Value is ******:#{var}"
      @@first_sample_product_id = page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
      get_voting_in_progress_SampleDetails(@@first_sample_product_id)
      expected_sample_name = $sample_name #Get sample name from database
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class='name']").text.should == expected_sample_name
    end

    it 'Verify pin icon is displaying in sample box' do
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class = 'pin']")
    end

    it 'Verify correct dollar amount appears above each sample' do
      expected_sample_price = $sample_price
      expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class = 'price']").text.should == expected_sample_price
    end

    it 'Verify all the samples on this page have "Pick" and "Skip" buttons.' do
      page.find(:xpath, "//a[@class = 'pick']").text.should == "PICK"
      page.find(:xpath, "//a[@class = 'skip']").text.should == "SKIP"
    end

    it 'Verify sample displays Vote count' do
      expected_vote_count = $vote_count
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div/div[@class = 'vote-count']").text.should == expected_vote_count
    end

    it 'Verify sample displays comment count' do
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div/div[@class = 'comments-count']").text.should == expected_sample_count
    end

    it 'Verify sample displays "Voting End date" with clock icon.' do
      voting_time_from_db = $voting_time
      expected_voting_time = get_voting_date_time(voting_time_from_db)
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class = 'status voting-in-progress']").text.should == expected_voting_time
    end

    it 'Verify when user clicks on sample image then user navigates to SDP' do
      sample_number = $sample_name.gsub("Sample ",'')
      page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class = 'photo']/a[@href='/samples/"+@@first_sample_product_id+"-sample-"+sample_number+"']").click
      page.current_url.should == "http://btb.demo.modcloth.com/samples/59038-sample-2166"    #need to check sdp page breadcrumb
      puts "HIIIIIIII"
      puts page.find(:xpath, "//div[@id='breadcrumbs']").text

    end
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
#end
#
#def get_first_sample_product_id
#  page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
#end

def get_voting_date_time(expected_voting_time)
  strlength = expected_voting_time.length
  days = expected_voting_time[0, 1]+"d"+" "

  if (strlength > 8)
    hours = expected_voting_time[7, 2]
    if (hours != "00")
      hours_first_number = hours[0, 1]

      if (hours_first_number == '0')
        hours = hours[1, 2]+"h"
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
        hours = hours[1, 2]+"h"
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
