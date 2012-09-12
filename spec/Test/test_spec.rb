# encoding: utf-8
require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  let(:page_title) { 'Voting In Progress' }
  expected_sample_count = get_voting_in_progress_SampleCount

  before(:all) do
    go_to_BTB_page1
    wait_for_script
  end

  #context "A. UI" do
  #  it '1. Verify "Voting In Progress" link is loading correct url and title.' do
  #    expected_path = current_url
  #    page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
  #    page.driver.browser.navigate.refresh
  #    page.current_url.should == expected_path
  #    page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == page_title
  #  end
  #
  #  it '2. Verify pagination displays correctly' do
  #    page.find(:xpath, "//div[@class = 'pagination']").text.should == 'Showing 1 - '+expected_sample_count+ ' of ' + expected_sample_count
  #  end
  #
  #  it '3. Verify user sees "Your Sample" section with correct title' do
  #    page.find(:xpath, "//div[@id = 'your-samples-header']").text.should == 'YOUR SAMPLES'
  #  end
  #
  #  it '4. Verify breadcrumb displays correct sequence with text' do
  #    page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress'
  #  end
  #
  #  it '5. Verify clicking on breadcrumb links load relevant pages.' do
  #    page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'ModCloth')]").click
  #    go_to_voting_in_progress_page
  #    page.find(:xpath, "//div[@id='breadcrumbs']/a[contains(text(),'Be The Buyer')]").click
  #    go_to_voting_in_progress_page
  #  end
  #
  #  it '6. Verify all samples have image' do
  #    sample_count = page.body.match(/of (\d+)/)[1]
  #    i = 1
  #    while (i != sample_count.to_i+1) do
  #      page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a/img[@src[contains(.,'http://s3.amazonaws.com/')]]")
  #      i = i+1
  #    end
  #  end
  #end
  #
  #context 'B. Sample Box' do
  #  it '' do
  #    FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').eq(0).attr('data-product-id')").to_s
  #    get_voting_in_progress_SampleDetails(FIRST_SAMPLE_PRODUCT_ID) #Get sample details from database
  #  end
  #
  #  it '1. Verify sample number is displaying correctly' do
  #    expected_sample_name = $sample_name #Get sample name from database
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='name']").text.should == expected_sample_name
  #  end
  #
  #  it '2. Verify pin icon is displaying in sample box' do
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'pin']")
  #  end
  #
  #  it '3. Verify correct dollar amount appears above each sample' do
  #    expected_sample_price = $sample_price
  #    expected_sample_price = "$"+expected_sample_price.insert(-3, '.')
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'price']").text.should == expected_sample_price
  #  end
  #
  #  it '4. Verify all the samples on this page have "Pick","Skip" buttons.' do
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'skip']").text.should == "SKIP"
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/a[@class = 'pick']").text.should == "PICK"
  #  end
  #
  #  it '5. Verify sample displays Vote count' do
  #    expected_vote_count = $vote_count
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'vote-count']").text.should == expected_vote_count
  #  end
  #
  #  it '6. Verify sample displays comment count' do
  #    commentable_name = $sample_name
  #    expected_comment_count = get_voting_in_progress_CommentCount(commentable_name)
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div/div[@class = 'comments-count']").text.should == expected_comment_count
  #  end
  #
  #  it '7. Verify sample displays "Voting End date" with clock icon.' do
  #    voting_time_from_db = $voting_time
  #    expected_voting_time = get_voting_date_time(voting_time_from_db)
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'status voting-in-progress']").text.should == expected_voting_time
  #  end
  #
  #  it '8. Verify when user clicks on sample image then user navigates to SDP' do
  #    sample_number = $sample_name.gsub("Sample ", '')
  #    page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'photo']/a[@href='/be-the-buyer/samples/"+FIRST_SAMPLE_PRODUCT_ID+"-sample-"+sample_number+"']").click
  #    page.find(:xpath, "//div[@id='breadcrumbs']").text.should == 'ModCloth » Be The Buyer » Voting In Progress » '+$sample_name
  #    go_to_BTB_page1
  #  end
  #end

  #context 'join' do
  #  it 'test' do
  #   join()
  #  end
  #end

  #context 'sign in' do
  #  it 'test' do
  #   sign_in()
  #   go_to_BTB_page1
  #  end
  #end
  #
  #context 'sign out' do
  #  it 'test' do
  #   sign_out()
  #  end
  #end

end

def go_to_voting_in_progress_page
  go_to_BTB_page1
  case $device_name
    when :phone
      join_phone()
    else
      page.find(:xpath, "//a[@href='/be-the-buyer/voting-in-progress']/li/div[contains(text(),'Voting In Progress')]").click
      page.find(:xpath, "//div[@class='sample-grid']/nav/h2[@class='page-title voting-in-progress']").text.should == 'Voting In Progress'
  end
end

def join()
  case $device_name
    when :phone
      join_phone()
    when :tablet
      join_tablet()
    else
      join_desktop()
  end
end


def join_desktop()
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

def join_tablet()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

def join_phone()     #pending
  within ('#mc-header-welcome') do
    page.find(:xpath, "//a[@id='mc-phone-header-join']").click
  end
  email_address = generate_new_email
  within ('#account-form') do
    fill_in 'Email Address', :with => email_address
    fill_in 'Password', :with => $password
    fill_in 'Confirm Password', :with => $password
    click_button('Join')
  end
  wait_for_script
end

def sign_in()
  case $device_name
      when :phone
        sign_in_phone()
      when :tablet
        sign_in_tablet()
      else
        sign_in_desktop()
    end
end

def sign_in_desktop()
  within ('#mc-header-personalization') do
    page.find(:xpath, "//a[@id='mc-header-sign-in']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  wait_for_script

  #name = $first_name
  #short_name = get_short_name(name)
  #within('#mc-header') do
  #  page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(short_name)
  #end
end

def sign_in_tablet()
  within ('#mc-header-welcome') do
    page.find(:xpath, "//div[@id='mc-header-sign-in']").click
    wait_for_script
  end
  within ('#login-form') do
    fill_in 'email', :with => $email
    fill_in 'sign_in_password', :with => $password
    click_button('Sign In')
  end
  wait_for_script

  #name = $first_name              #Need to uncomment this part once issue gets fixed
  #short_name = get_short_name(name)
  #within('#mc-header') do
  #  page.find(:xpath, "//div[@id='member-dropdown']").text.should eq(short_name)
  #end
  #should_be_signed_in_as_user()    #Need to uncomment this once issue gets fixed. THIS IS TEMPORARY
end

def sign_out()
  case $device_name
      when :phone
        sign_out_phone()
      when :tablet
        sign_out_tablet()
      else
        sign_out_desktop()
    end
end

def sign_out_desktop()
  puts "hello"
  page.find(:xpath, "//a[@id = 'mc-header-sign-out']").click
  wait_for_script
  within('#mc-header-personalization') do
    page.should have_link('Sign In')
  end
end

def sign_out_tablet()
    page.find(:xpath, "//div[@class = 'name-and-arrow']/div").click
    page.find(:xpath, "//a[@class = 'sign-out']").click
    page.should have_xpath("//div[@id = 'mc-header-join-or-sign-in']")
end

def sign_out_phone()

end

#----------------------------------------------------------

describe 'Desktop header' do

  before(:all) do
    go_to_BTB_page1
    wait_for_script
  end

  it 'Verify user see "Curstomer Care" link.' do
  within ('#mc-header-links') do
    page.should have_link('Customer Care')
  end
  end

  it 'Verify when user clicks on "Customer Care" link it opens correct window' do

  end

  it 'Verify when user clicks on username then user navigates to dashboard.' do

  end

  it 'Verify when user clicks on Notifications then user navigates to Restock notification page' do

  end

  it 'Verify when user clicks on Wishlist then user navigates to wishlist page' do

  end

  it 'Verify when user clicks on Order History then user navigates to order history page.' do

  end

  it 'Verify when user clicks on Loved items then user navigates to loved items page.' do

  end

  it 'Verify when Loved item count displays correctly.' do

  end

  it 'Verify user see text "Shopping bag"' do

  end

  it 'Verify user see correct shopping count' do

  end

  it 'Verify user see "Checkout" button' do

  end

  it 'Verify when user clicks on "Checkout" button then user see checkout flow' do

  end

  it 'Verify user see "Search" text box with text "Search"' do

  end
end

describe 'Search' do

end








