# encoding: utf-8
require "spec/spec_helper"

describe 'SDP - Voting In Progress' do
  let(:page_title) { 'Voting In Progress' }

  before(:all) do
    go_to_BTB_page
    go_to_available_now_page
  end

  #it 'Verify breadcrumb displays in this format ModCloth » Be The Buyer » Available Now' do
  #  breadcrumb_text = page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text
  #  breadcrumb = breadcrumb_text.tr("\n","")
  #  breadcrumb.should == 'ModCloth »Be the Buyer » Available Now'
  #end
  #
  #it 'Verify page title displays "Be the Buyer | Available now " pick.' do
  #  page.find(:xpath, "//div[@id = 'page_title']").text.should == "Be the Buyer » Available Now"
  #end
  #
  #it 'Verify left side navigation is updated to "Be the Buyer Available Now" This can be on two lines.' do
  #  page.find(:xpath, "//div[@id = 'left_nav']/div[@class='category_navigation']/ul/li/a").text.should == "BE THE BUYER » AVAILABLE NOW"
  #end

  it 'Get first product from grid' do
      First_sample_product_id = page.evaluate_script("$('.product_list li').eq(0).attr('data-id')").to_s
      puts "product is: #{First_sample_product_id}"
  end

  #it 'Verify PDP functionality' do
  #    page.find(:xpath, "//ul[@class = 'product_list']/li[@data-id="+First_sample_product_id+"]/a[2]", :visible => true).click
  #    wait_until {page.find(:xpath, "//div[@class='product-detail-page ']", :visible => true)}
  #    go_to_available_now_page
  #  end

  context 'A. Breadcrumb', :no_phone => true do

  end
end
