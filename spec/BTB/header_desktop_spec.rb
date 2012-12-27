require 'spec/support/common_helper'

describe 'Desktop header', :no_phone => true, :no_tablet => true do

  context "Non Logged In User" do
    before(:all) do
      go_to_BTB_page
    end

    it 'Verify user see "Curstomer Care" link.' do
      within ('#mc-header-links') do
        page.should have_link('Customer Care')
      end
    end

    it 'Verify when user clicks on "Customer Care" link it opens correct window' do
      page.find(:xpath, "//a[@id = 'mc-header-customer-care']").click
      wait_for_script
      new_window = page.driver.browser.window_handles.last
      page.within_window new_window do
        page.has_xpath?("//div[@id = 'mc-modal-dialog-header']", :visible => true)
        page.find(:xpath, "//div[@id = 'mc-modal-dialog-title']").text.should == "ModCloth Customer Care"
        page.find(:xpath, "//div[@id = 'mc-modal-dialog-close']").click
      end
    end

    it 'Verify user see Join link' do
      page.find(:xpath, "//a[@id = 'mc-header-join']").text.should == "Join"
    end

    it 'Verify user see Sign in link' do
      page.find(:xpath, "//a[@id = 'mc-header-sign-in']").text.should == "Sign In"
    end

    it 'Verify user see "Search" text box with text "Search"' do
      page.should have_xpath("//input[@id = 'mc-header-keyword' and @placeholder = 'Search']")
    end

    it 'Verify user see text "Shopping bag"' do
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").text.should == "SHOPPING BAG"
    end
  end

  context "Sign In" do
    it 'Verify Sign in functionality and after successful sign in user navigates to BTB homepage.' do
      go_to_BTB_page
      click_sign_in_link
      sign_in
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end

  context "Header" do
    before(:each) do
      go_to_BTB_page
    end

    it 'Verify top nav links navigate user to correct page.' do
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

    it 'Verify when user clicks on "Shopping bag" link then user navigates to correct link' do
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']", :visible => true).click
      page.find(:xpath, "//h2[@id = 'shopping-bag-header']", :visible => true)
    end

    it 'Verify when user clicks on username then user navigates to dashboard.' do
      page.find(:xpath, "//a[@id = 'mc-header-welcome-name']", :visible => true).click
      page.find(:xpath, "//h2[@class = 'myaccount-box-header']", :visible => true)
    end

    it 'Verify when user clicks on Notifications then user navigates to Restock notification page' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/customers/notifications']", :visible => true).click
      page.find(:xpath, "//div[@id = 'restock']/h2/p[@class = 'float-left']", :visible => true)
      page.find(:xpath, "//div[@id = 'restock']/h2/p[@class = 'float-left']").text.should == 'Restock Notifications'
    end

    it 'Verify when user clicks on Wishlist then user navigates to wishlist page' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/storefront/wishlists' and text() = 'Wishlists']", :visible => true).click
      page.has_xpath?("//h2[@class = 'myaccount-box-header']", :visible => true)
      page.find(:xpath, "//div[@class = 'myaccount-box large']/h2").text.should == "Create A New Wishlist"
    end

    it 'Verify when user clicks on Order History then user navigates to order history page.' do
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']", :visible => true).click
      page.find(:xpath, "//a[@href = '/customers/orders']", :visible => true).click
      page.has_xpath?("//div[@id = 'myaccount-right']/div[@class = 'myaccount-box large']/h2", :visible => true)
      page.find(:xpath, "//div[@id = 'myaccount-right']/div[@class = 'myaccount-box large']/h2").text.should =='Order History'
    end

    it 'Verify when user clicks on Loved items then user navigates to loved items page.' do
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a", :visible => true).click
      page.find(:xpath, "//div[@id = 'category-header']/h1", :visible => true)
      page.find(:xpath, "//div[@id = 'category-header']/h1").text.should == 'My Loved Items'
    end

    it 'Verify "Loved item" count displays correctly.' do
      page.has_xpath?("//div[@id = 'mc-header-loved-items']/a", :visible => true)
      expected_count = page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").text

      #actual_love_count = a_var[1..-1].chomp(')')
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").click
      actual_count = page.find(:xpath, "//a[@id = 'header-loved-items-link-with-count']", :visible => true).text
      expected_count.should == actual_count
    end

    #it 'Verify user see correct shopping bag count.' do
    #  add_product_into_shopping_bag
    #  go_to_BTB_page
    #  page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
    #  expected_count = page.find(:xpath, "//em[@class = 'item_count']").text
    #  go_to_BTB_page
    #  a_var = page.find(:xpath, "//a[@id = 'mc-header-cart-count']").text
    #  actual_count = a_var[2..-1].chomp(' )')
    #  expected_count.should == actual_count
    #  remove_product_from_shopping_bag
    #end
    #
    #it 'Verify user see "Checkout" button' do
    #  add_product_into_shopping_bag
    #  go_to_BTB_page
    #  page.should have_xpath("//a[@id = 'mc-header-checkout-button' and text() = 'CHECKOUT']")
    #  remove_product_from_shopping_bag
    #end
    #
    #it 'Verify when user clicks on "Checkout" button then user see checkout flow' do
    #  puts "PENDING"
    #end
  end

  context 'Search functionality' do
    before(:each) do
      go_to_BTB_page
    end

    it 'Valid case' do
      go_to_available_now_page
      get_product = page.evaluate_script('$(".product_list li:eq(0) p").text()').to_s
      puts "product is:#{get_product} "
      if (get_product == '')
        fail "No product found for Search test cases."
      else
        go_to_BTB_page
        page.find(:xpath,"//input[@id = 'mc-header-keyword']", :visible => true)
        fill_in 'mc-header-keyword', :with => get_product.strip
        wait_for_script
        click_button('GO')
        wait_for_script
        page.find("//div[@id = 'page_title']/h1", :visible => true)
        page.find(:xpath, "//ul[@class = 'product_list']/li/a/p", :visible => true).text.should == get_product.strip
      end
    end

    it 'Invalid case - with blank search' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      fill_in 'mc-header-keyword', :with => ''
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find("//div[@class = 'header']", :visible => true)
      page.find(:xpath, "//div[@class = 'message']").text().should == "Search term must be at least 3 characters in length"
    end

    it 'Invalid case - with no result found' do
      page.has_xpath?("//input[@id = 'mc-header-keyword']", :visible => true)
      search_text = 'Ffhkjdhfgkhdfgkjdfhgkjhdfkjfhgkj'.strip
      fill_in 'mc-header-keyword', :with => search_text
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find("//div[@id = 'page_title']/h1", :visible => true)
      expected = 'Sorry, no results found for '+'"'+search_text+'"'+'. Please try another search'
      page.find(:xpath, "//div[@class = 'search-no-results']").text().should == expected
    end
  end

  context "Sign Out" do
    it 'Verify when user clicks on Sign out link then user signed out successfully and remains on same page.' do
      go_to_BTB_page
      sign_out
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end

  context "Join" do
    it 'Verify "Join" functionality and after successful join user navigates to BTB homepage.' do
      go_to_BTB_page
      join()
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
      sign_out()
    end
  end

  context "Facebook" do
    it 'Verify "Facebook Sign In" functionality' do
      go_to_BTB_page
      click_sign_in_link
      sign_in_with_facebook()
      wait_for_script
      page.find(:xpath, "//div[@id = 'btb-logo']", :visible => true)
    end
  end
end







