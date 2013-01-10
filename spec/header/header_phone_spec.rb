#require 'spec/support/common_helper'
require "spec/spec_helper"

describe 'Header - header_phone', :no_desktop => true, :no_tablet => true do

  context 'I. UI' do
    before(:all) do
      go_to_BTB_page
    end

    it '1. Verify clicking on modcloth logo loads modcloth home page.' do
      page.find(:xpath, "//div[@class = 'logo']", :visible => true).click
      page.find(:xpath, "//a[@id = 'logo']", :visible => true)
      page.should have_xpath("//a[@id = 'logo']")
      go_to_BTB_page
    end

    it '2. Verify clicking on BTB logo loads Be The Buyer page.' do
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true).click
      wait_until { page.should have_content('Voting In Progress') }
    end

    it "3. Verify user see text 'Showing' with drop down option displays following options with correct text & icon -
      - Voting in Progress
      - Awaiting Results
      - In Production
      - Avaialble Now" do

      page.find(:xpath, "//div[@id='menu-toggle']", :visible => true).click
      page.has_xpath?("//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/voting-in-progress']/li/div", :visible => true)
      #wait_until { page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/voting-in-progress']/li/div").visible? == true }
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/voting-in-progress']/li/div").text.should == "Voting In Progress"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/awaiting-results']/li/div").text.should == "Awaiting Results"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/in-production']/li/div").text.should == "In Production"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/available-now']/li/div").text.should == "Available Now"
    end

    it "4. Verify when user clicks on 'MENU' option then all category links gets displayed." do
      #page.has_xpath?("//div[@id = 'mc-header-menu-toggle']", :visible => true)
      page.find(:xpath, "//div[@id = 'mc-header-menu-toggle']", :visible => true).click
      page.has_xpath?("//div[@id = 'mc-header-menu-dropdown']/ul/a", :visible => true)
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[1]/li").text.should == "NEW ARRIVALS"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[2]/li").text.should == "CLOTHING"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[3]/li").text.should == "SHOES"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[4]/li").text.should == "BAGS & ACCESSORIES"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[5]/li").text.should == "APARTMENT"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[6]/li").text.should == "SALE"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[7]/li").text.should == "BE THE BUYER"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[8]/li").text.should == "STYLE GALLERY"
      page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[9]/li").text.should == "VINTAGE"
    end

    it '5. Verify user see Search text box with submit button.' do
      page.should have_xpath("//input[@id = 'mc-header-keyword']")
      page.should have_xpath("//input[@id = 'mc-header-search-button']")
    end

    it '6. Verify user see Join or Sign in link' do
      page.should have_xpath("//a[@id = 'mc-phone-header-join']")
      page.should have_xpath("//a[@id = 'mc-phone-header-join']", :text => 'Join or Sign In')
    end

    it '7. Verify user see shopping bag with count 0' do
      page.should have_xpath("//a[@id = 'mc-phone-header-bag']")
      page.should have_xpath("//a[@id = 'mc-phone-header-bag']", :text => "0")
    end

    it '8. PENDING Verify all Menu category links are working correctly.' do #Need to add style gallary & BTB links
      menu_count = 1
      begin
        page.find(:xpath, "//div[@id = 'mc-header-menu-toggle']", :visible => true).click
        page.has_xpath?("//div[@id = 'mc-header-menu-dropdown']", :visible => true)

        page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a["+menu_count.to_s+"]/li").click
        wait_for_script
        page.has_xpath?("//h1[@id = 'category-header']", :visible => true)
        case menu_count
          when 1
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'New Arrivals'

          when 2
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Clothing'

          when 3
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Shoes'

          when 4
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Bags & Accessories'

          when 5
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Apartment'

          when 6
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Sale'

          when 7
            #page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Be The Buyer'

          when 8
            #page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Clothing'

          when 9
            page.find(:xpath, "//h1[@id = 'category-header']").text.should == 'Vintage'

        end
        go_to_BTB_page
        menu_count = menu_count + 1
      end while (menu_count != 10)
    end

    it '9. Verify when user clicks on Shopping bag icon, user navigates to shopping bag page.' do
      page.find(:xpath, "//a[@id = 'mc-phone-header-bag']").click
      page.has_xpath?("//h1[@id = 'category-header']/span", :visible => true)
      page.should have_xpath("//h1[@id = 'category-header']/span", :text => 'Shopping Bag')
    end
  end

  context "Sign In" do
    it '1. Verify Sign in functionality and after successful sign in user navigates to BTB homepage.' do
      go_to_BTB_page
      click_sign_in_link
      sign_in
      wait_for_script
      page.should have_xpath("//div[@id = 'btb-logo']")
    end
  end

  context "II. Functional Tests" do
    before(:each) do
      go_to_BTB_page
      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a[@class = 'member-dropdown']", :visible => true).click
    end

    it '2. Verify when user clicks on username then user see following options -
            Wishlist
            Order history
            Loved items
            Sign out' do

      page.has_xpath?("//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/wishlists']", :visible => true)
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/wishlists']").text.should == "WISHLISTS"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/customers/orders']").text.should == "ORDER HISTORY"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/lovelists/show']").text.should == "LOVED ITEMS"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/logout']").text.should == "SIGN OUT"
      wait_for_script
    end

    it '3. Verify when user clicks on Wishlist then user navigates to wishlist page' do
      #page.has_xpath?("//a[@href = '/storefront/wishlists']", :visible => true)
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/wishlists']", :visible => true).click
      page.has_xpath?("//div[@id = 'mobile-wishlists']/h1", :visible => true)
      #wait_until(Capybara.default_wait_time) {
      #page.find(:xpath, "//div[@id = 'mobile-wishlists']/h1").text.should == "Wishlists" }
      page.should have_xpath("//div[@id = 'mobile-wishlists']/h1", :text => 'Wishlists')
    end

    it '4. Verify when user clicks on Order History then user navigates to Order History page' do
      page.find(:xpath, "//a[@href = '/customers/orders']", :visible => true).click
      page.has_xpath?("//div[@id = 'mobile-order-history-header']/h1", :visible => true)
      page.should have_xpath("//div[@id = 'mobile-order-history-header']/h1", :text => "Order History")
    end

    it '5. Verify when user clicks on Loved Items then user navigates to Loved Items page' do
      page.find(:xpath, "//a[@href = '/storefront/lovelists/show']", :visible => true).click
      page.has_xpath?("//h1[@id = 'category-header']", :visible => true)
      page.should have_xpath("//h1[@id = 'category-header']", :text => "My Loved Items")
    end

    it '6. Verify when user clicks on Sign out option then user gets signed out and user remains on same page.' do
      page.find(:xpath, "//a[@class = 'button button-medium']", :visible => true).click
      page.has_xpath?("//a[@id = 'mc-phone-header-join']", :visible => true)
      page.should have_xpath("//a[@id = 'mc-phone-header-join']", :text => "Join or Sign In")
      page.should have_xpath("//div[@id = 'btb-logo']")
    end
  end

  context 'III. Search' do
    before(:each) do
      go_to_BTB_page
    end
    it 'Valid case' do
      go_to_available_now_page
      get_product = page.evaluate_script('$("#product-grid li:eq(0) p").text()').to_s
      if (get_product == '')
        fail "No product found for Search test cases."
      else
        go_to_BTB_page
        page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
        fill_in 'mc-header-keyword', :with => get_product.strip
        wait_for_script
        click_button('GO')
        wait_for_script
        page.find(:xpath, "//p[@class = 'title']", :visible => true).text.should == get_product.strip
      end
    end

    it 'Invalid case - with blank search' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      fill_in 'mc-header-keyword', :with => ''
      wait_for_script
      click_button('GO')
      wait_for_script
      page.should have_xpath("//div[@id = 'header']/a[@id = 'logo']")
    end

    it 'Invalid case - with no result found' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      search_text = 'Ffhkjdhfgkhdfgkjdfhgkjhdfkjfhgkj'.strip
      fill_in 'mc-header-keyword', :with => search_text
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find(:xpath, "//h1[@id = 'category-header']/span").text.should == "\""+search_text+"\""
      page.find(:xpath, "//div[@id = 'no-results-block']/p").text.should == "Sorry, no results were found."
      page.find(:xpath, "//div[@id = 'no-results-block']/p[@class = 'try-again']").text.should == "Please try another search."
    end

    it 'Verify user see correct shopping bag count on BTB site and on modcloth site.' do
      btb_bag_count = page.find(:xpath, "//a[@id = 'mc-phone-header-bag']", :visible => true).text
      page.find(:xpath, "//a[@id = 'mc-phone-header-bag']").click
      wait_for_script
      modcloth_bag_count = page.find(:xpath, "//a[@id = 'header-shopping-bag-link']/span", :visible => true).text
      btb_bag_count.to_i.should == modcloth_bag_count.to_i
    end
  end

  context "IV. Join" do
    it 'Verify "Join" functionality and after scuccessful join user navigates to BTB homepage.' do
      go_to_BTB_page
      join()
      page.should have_xpath("//div[@id = 'btb-logo']", :visible => true)
      sign_out()
    end
  end

  context "V. Facebook Sign in" do
    it 'Verify after successful facebook sign in user navigates to BTB homepage' do
      go_to_BTB_page
      click_sign_in_link
      sign_in_with_facebook()
      page.should have_xpath("//div[@id = 'btb-logo']", :visible => true)
    end
  end
end

