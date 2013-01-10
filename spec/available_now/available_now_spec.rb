# encoding: utf-8
require "spec/spec_helper"

describe 'Available_now - Available_now_spec' do
  before(:all) do
    go_to_BTB_page
    go_to_available_now_page
  end

  it '1. Verify breadcrumb displays in this format ModCloth » Be The Buyer » Available Now' do
    breadcrumb_text = page.find(:xpath, "//div[@id='breadcrumbs']", :visible => true).text
    breadcrumb = breadcrumb_text.tr("\n", "")
    breadcrumb.should == 'ModCloth »Be the Buyer » Available Now'
  end

  it '2. Verify page title displays "Be the Buyer | Available now " pick.' do
    if ($device_name == :tablet)
      within ('#grid-page-view') do
        page.should have_content("Be the Buyer » Available Now")
      end
    elsif ($device_name == :phone)
      page.find(:xpath, "//h1[@id = 'category-header']/span").text.should == "Be the Buyer » Available Now"
    elsif ($device_name == :desktop)
      page.find(:xpath, "//div[@id = 'page_title']").text.should == "Be the Buyer » Available Now"
    end
  end

  it '3. Verify left side navigation is updated to "Be the Buyer Available Now" This can be on two lines.', :no_phone => true, :no_tablet => true do
    page.find(:xpath, "//div[@id = 'left_nav']/div[@class='category_navigation']/ul/li/a").text.should == "BE THE BUYER » AVAILABLE NOW"
  end

  it '4. Verify PDP functionality' do
    if ($device_name == :phone)
      page.find(:xpath, "//ul[@class = 'product_list']/li[1]", :visible => true).click
      wait_until { page.find(:xpath, "//div[@id='pdp-container']", :visible => true) }
    elsif ($device_name == :desktop)
      page.find(:xpath, "//ul[@class = 'product_list']/li[@class='first']/a[2]", :visible => true).click
      wait_until { page.find(:xpath, "//div[@class='product-detail-page ']", :visible => true) }
    elsif ($device_name == :tablet)
      page.find(:xpath, "//div[@id = 'product-grid']/a[1]", :visible => true).click
      wait_until { page.find(:xpath, "//div[@id='product-summary']", :visible => true) }
    end
    go_to_available_now_page
  end
end
