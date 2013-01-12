require 'spec/spec_helper'

describe 'Header - header_desktop_spec', :no_phone => true, :no_tablet => true do

  context "I. Non Logged In User" do
    before(:all) do
      go_to_BTB_page
    end

    it '1. Verify user see "Curstomer Care" link.' do
      within ('#mc-header-links') do
        page.should have_link('Customer Care')
      end
    end

    it '2. Verify when user clicks on "Customer Care" link it opens correct window' do
      page.find(:xpath, "//a[@id = 'mc-header-customer-care']").click
      wait_for_script
      new_window = page.driver.browser.window_handles.last
      page.within_window new_window do
        page.has_xpath?("//div[@id = 'mc-modal-dialog-header']", :visible => true)
        page.find(:xpath, "//div[@id = 'mc-modal-dialog-title']", :visible => true).text.should == "ModCloth Customer Care"
        page.find(:xpath, "//div[@id = 'mc-modal-dialog-close']", :visible => true).click
      end
    end

    it '3. Verify user see Join link' do
      page.find(:xpath, "//a[@id = 'mc-header-join']", :visible => true).text.should == "Join"
    end

    it '4. Verify user see Sign in link' do
      page.find(:xpath, "//a[@id = 'mc-header-sign-in']", :visible => true).text.should == "Sign In"
    end

    it '5. Verify user see "Search" text box with text "Search"' do
      page.should have_xpath("//input[@id = 'mc-header-keyword' and @placeholder = 'Search']")
    end

    it '6. Verify user see text "Shopping bag"' do
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']", :visible => true).text.should == "SHOPPING BAG"
    end

    it '7. Verify when user click on Checkout button, user navigates to sign in page. After successful sign in user should see regular checkout flow. ' do
      add_item_into_bag_desktop
      go_to_BTB_page
      page.find(:xpath, "//a[@id = 'mc-header-checkout-button']", :visible => true).click
      wait_until {
        page.find(:xpath, "//div[@id = 'checkout-title-container']", :visible => true)
        sign_in_on_desktop_for_checkout
      }
    end
  end

  context "II. Sign In" do
    it '1. Verify Sign in functionality and after successful sign in user navigates to BTB homepage.' do
      go_to_BTB_page
      click_sign_in_link
      sign_in
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end

  context "III. Header" do
    before(:each) do
      go_to_BTB_page
    end

    it '1. Verify top nav links navigate user to correct page.' do
      menu_count = 1
      begin
        page.has_xpath?("//ul[@id = 'mc-header-navigation']", :visible => true)
        page.find(:xpath, "//ul[@id = 'mc-header-navigation']/li["+menu_count.to_s+"]/a").click
        wait_for_script
        page.has_xpath?("//div[@id = 'page_title']/h1", :visible => true)
        case menu_count
          when 1
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == "New Arrivals"
          when 2
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'Vintage-Inspired Clothing'
          when 3
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'Cute Shoes'
          when 4
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'Cute Accessories'
          when 5
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'Apartment Decor & Accessories'
          when 6
            #page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == ''
          when 7
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == "Women's Vintage Clothes"
          when 8
            #page.find(:xpath, "//h1[@id = 'category-header']").text.should == ''
          when 9
            page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'Sale Clothing & Accessories'
        end
        go_to_BTB_page
        menu_count = menu_count + 1
      end while (menu_count != 10)
    end

    it '2. Verify when user clicks on "Shopping bag" link then user navigates to correct link' do
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']", :visible => true).click
      page.find(:xpath, "//h2[@id = 'shopping-bag-header']", :visible => true)
    end

    it '3. Verify when user clicks on username then user navigates to dashboard.' do
      page.find(:xpath, "//a[@id = 'mc-header-welcome-name']", :visible => true).click
      page.find(:xpath, "//h2[@class = 'myaccount-box-header']", :visible => true)
    end

    it '4. Verify when user clicks on Notifications then user navigates to Restock notification page' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/customers/notifications']", :visible => true).click
      page.find(:xpath, "//div[@id = 'restock']/h2/p[@class = 'float-left']", :visible => true)
      page.find(:xpath, "//div[@id = 'restock']/h2/p[@class = 'float-left']").text.should == 'Restock Notifications'
    end

    it '5. Verify when user clicks on Wishlist then user navigates to wishlist page' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/storefront/wishlists' and text() = 'Wishlists']", :visible => true).click
      page.has_xpath?("//h2[@class = 'myaccount-box-header']", :visible => true)
      page.find(:xpath, "//div[@class = 'myaccount-box large']/h2").text.should == "Create A New Wishlist"
    end

    it '6. Verify when user clicks on Order History then user navigates to order history page.' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/customers/orders']", :visible => true).click
      page.has_xpath?("//div[@id = 'myaccount-right']/div[@class = 'myaccount-box large']/h2", :visible => true)
      page.find(:xpath, "//div[@id = 'myaccount-right']/div[@class = 'myaccount-box large']/h2").text.should =='Order History'
    end

    it '7. Verify when user clicks on Loved items then user navigates to loved items page.' do
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a", :visible => true).click
      page.find(:xpath, "//div[@id = 'page_title']/h1", :visible => true)
      page.find(:xpath, "//div[@id = 'page_title']/h1").text.should == 'My Loved Items'
    end

    it '8. Verify "Loved item" count displays correctly.' do
      page.has_xpath?("//div[@id = 'mc-header-loved-items']/a", :visible => true)
      expected_count = page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").text
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").click
      actual_count = page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a", :visible => true).text
      expected_count.should == actual_count
    end

    it '9. Verify user see correct shopping bag count.' do
      add_item_into_bag_desktop
      actual_count = page.find(:xpath, "//a[@id = 'mc-header-cart-count']", :visible => true).text
      #actual_count = a_var[2..-1].chomp('item )')
      go_to_BTB_page
      expected_count = page.find(:xpath, "//a[@id = 'mc-header-cart-count']", :visible => true).text
      expected_count.should == actual_count
    end

    it '10. Verify user see "Checkout" button' do
      go_to_BTB_page
      page.should have_xpath("//a[@id = 'mc-header-checkout-button' and text() = 'CHECKOUT']")
    end

    it '11. Verify when user clicks on "Checkout" button then user see verification page.' do
      page.find(:xpath, "//a[@id = 'mc-header-checkout-button']", :visible => true).click
      wait_until {
        page.find(:xpath, "//div[@id = 'checkout-title-container']", :visible => true) }
    end
  end

  context 'IV. Search functionality' do
    before(:each) do
      go_to_BTB_page
    end

    it '1. Valid case' do
      go_to_available_now_page
      get_product = page.evaluate_script('$(".product_list li:eq(0) p").text()').to_s
      if (get_product == '')
        fail "No product found for Search test cases."
      else
        go_to_BTB_page
        page.find(:xpath, "//input[@id = 'mc-header-keyword']", :visible => true)
        fill_in 'mc-header-keyword', :with => get_product.strip
        wait_for_script
        click_button('GO')
        wait_for_script
        page.find(:xpath, "//div[@id = 'page_title']/h1", :visible => true)
        page.find(:xpath, "//ul[@class = 'product_list']/li/a/p", :visible => true).text.should == get_product.strip
      end
    end

    it '2. Invalid case - with blank search' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      fill_in 'mc-header-keyword', :with => ''
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find(:xpath, "//div[@class = 'header']", :visible => true)
      page.find(:xpath, "//div[@class = 'message']").text().should == "Search term must be at least 3 characters in length"
    end

    it '3. Invalid case - with no result found' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      search_text = 'Ffhkjdhfgkhdfgkjdfhgkjhdfkjfhgkj'.strip
      fill_in 'mc-header-keyword', :with => search_text
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find(:xpath, "//div[@id = 'page_title']/h1", :visible => true)
      expected = 'Sorry, no results found for '+'"'+search_text+'"'+'. Please try another search'
      page.find(:xpath, "//div[@class = 'search-no-results']").text().should == expected
    end
  end

  context "V. Sign Out" do
    it '1. Verify when user clicks on Sign out link then user signed out successfully and remains on same page.' do
      go_to_BTB_page
      sign_out
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end

  context "VI. Join" do
    it '1. Verify "Join" functionality and after successful join user navigates to BTB homepage.' do
      go_to_BTB_page
      join()
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
      sign_out()
    end
  end

  context "VII. Facebook" do
    it '1. Verify "Facebook Sign In" functionality' do
      go_to_BTB_page
      click_sign_in_link
      sign_in_with_facebook()
      wait_for_script
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end
end

#describe 'Test' do
#  it 'TT' do
#    visit '/' + 'shop/dresses'
#    wait_until {
#      page.find(:xpath, "//div[@id = 'page_title']", :visible => true) }
#
#    add_item_into_bag
#    actual_count = page.find(:xpath, "//a[@id = 'mc-header-cart-count']", :visible => true).text
#    #puts "Actual Count is: #{a_var}"
#    #actual_count = a_var[2..-1].chomp('item )')
#    puts "actaul count is: #{actual_count}"
#    go_to_BTB_page
#    expected_count = page.find(:xpath, "//a[@id = 'mc-header-cart-count']", :visible => true).text
#    puts "Expected count is: #{expected_count}"
#    expected_count.should == actual_count
#  end
#end







