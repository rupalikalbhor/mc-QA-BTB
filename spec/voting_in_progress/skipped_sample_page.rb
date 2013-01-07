# encoding: utf-8
require "spec/spec_helper"

describe 'Skipped Sample page' do

  before(:all) do
    go_to_BTB_page
  end

  it '1. Go to Skipped sample page.' do
    product_id = get_product_id_for_skipped_sample
    visit '/' + 'be-the-buyer/samples/'+product_id
    wait_for_script
    #Sample_name = page.find(:xpath, "//div[@class = 'name']", :visible => true).text
  end

  it '2. Verify page title displays Skipped.', :no_phone => true do
    if($device_name == :phone)
    page.find(:xpath, "//div[@class = 'state-instructions-sharing-section']/h2", :visible => true).text.should == 'Skipped'
    else
      page.find(:xpath, "//div[@class = 'state-instructions-sharing-section']/h2", :visible => true).text.should == 'SKIPPED'
    end
  end

  it '3. Verify user see message The community didnt choose this sample in left side section' do
    page.find(:xpath, "//div[@class = 'state-instructions-sharing-section']/p", :visible => true).text.should == "The community didn't choose this sample"
  end

  it '4. Verify user see Skipped text and community message above the sample image.' do
      page.find(:xpath, "//div[@class = 'voting-and-notification']/h3", :visible => true).text.should == 'SKIPPED -'
      page.find(:xpath, "//div[@class = 'voting-and-notification']/p", :visible => true).text.should == "The community didn't choose this sample"
  end

  it '5. Verify there is not "prev" or "next" button.' do
    page.should_not have_xpath("//nav[@class = 'prev-next']/a[@class = 'prev']")
    page.should_not have_xpath("//nav[@class = 'prev-next']/a[@class = 'next']")
  end
end

