require 'spec/support/common_helper'

describe 'Desktop header' do
  context "Logged out user" do
    before(:all) do
      go_to_BTB_page
      wait_for_script
    end
    it 'Verify user see "Curstomer Care" link.' do
      within ('#mc-header-links') do
        page.should have_link('Customer Care')
      end
    end

    it 'Verify when user clicks on "Customer Care" link it opens correct window' do
      puts "PENDING TEST CASE"
    end

    it 'Verify user see Join link' do
      page.should have_xpath("//a[@id = 'mc-header-join' and @href = '#' and text() = 'Join']")
    end

    it 'Verify user see Sign in link' do
      page.should have_xpath("//a[@id = 'mc-header-sign-in' and @href = '#' and text() = 'Sign In']")
    end

    it 'Verify user see "Search" text box with text "Search"' do
      go_to_BTB_page
      page.should have_xpath("//input[@id = 'mc-header-keyword' and @placeholder = 'Search']")
    end

    it 'Verify user see text "Shopping bag"' do
      go_to_BTB_page
      page.should have_xpath("//a[@id = 'mc-header-shopping-bag' and text() = 'SHOPPING BAG']")
    end

    it 'Verify when user clicks on "Shopping bag" link then user navigates to correct link' do
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
      page.should have_xpath("//h2[@id = 'shopping-bag-header']/strong[text() = 'Your Shopping Bag is Empty']") #need to add xpath
    end

    it 'Verify user see correct shopping bag count' do
      add_product_into_shopping_bag
      go_to_BTB_page
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
      expected_count = page.find(:xpath, "//em[@class = 'item_count']").text
      go_to_BTB_page
      a_var = page.find(:xpath, "//a[@id = 'mc-header-cart-count']").text
      actual_count = a_var[2..-1].chomp(' )')
      expected_count.should == actual_count
      remove_product_from_shopping_bag
    end

    it 'Verify when user add item into shopping bag, Checkout button gets enabled.' do
      add_product_into_shopping_bag
      go_to_BTB_page
      wait_for_script
      page.should have_xpath("//a[@id = 'mc-header-checkout-button' and text() = 'CHECKOUT']")
      remove_product_from_shopping_bag
    end

    it 'Verify checkout functionality' do
      puts "PENDING ******"
    end

    it 'Verify "Join" functionality' do
      go_to_BTB_page
      join() #Call this function from common helper
      sign_out()
    end
  end

  context "Logged In user" do
    before(:all) do
      go_to_BTB_page
      wait_for_script
      sign_in()
      wait_for_script
    end

    it 'Verify user see "Curstomer Care" link.' do
      within ('#mc-header-links') do
        page.should have_link('Customer Care')
      end
    end

    it 'Verify when user clicks on "Customer Care" link it opens correct window' do
      puts "PENDING TEST CASE"
    end

    it 'Verify when user clicks on username then user navigates to dashboard.' do
      go_to_BTB_page
      wait_for_script
      page.find(:xpath, "//a[@id = 'mc-header-welcome-name']").click
      page.should have_xpath("//h2[@class = 'myaccount-box-header']")
    end

    it 'Verify when user clicks on Notifications then user navigates to Restock notification page' do
      go_to_BTB_page
      wait_for_script
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/customers/notifications']").click
      wait_for_script
      page.should have_xpath("//p[@class = 'float-left' and text() = 'Restock Notifications']")
    end

    it 'Verify when user clicks on Wishlist then user navigates to wishlist page' do
      go_to_BTB_page
      wait_for_script
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/storefront/wishlists' and text() = 'Wishlists']").click
      wait_for_script
      page.should have_xpath("//h2[@class = 'myaccount-box-header']")
    end

    it 'Verify when user clicks on Order History then user navigates to order history page.' do
      go_to_BTB_page
      wait_for_script
      page.find(:xpath, "//a[@id = 'mc-header-pulldown']").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/customers/orders']").click
      wait_for_script
      page.should have_xpath("//h2[@class = 'myaccount-box-header no-left-nav-overide' and text() = 'Order History']")
    end

    it 'Verify when user clicks on Loved items then user navigates to loved items page.' do
      go_to_BTB_page
      wait_for_script
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").click
      wait_for_script
      within ('#category-header') do
        page.should have_content('My Loved Items')
      end
    end

    it 'Verify "Loved item" count displays correctly.' do
      go_to_BTB_page
      page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").click
      wait_for_script
      expected_love_count = page.evaluate_script("$('.product_cat_view').length").to_s
      go_to_BTB_page
      a_var = page.find(:xpath, "//div[@id = 'mc-header-loved-items']/a").text
      actual_love_count = a_var[1..-1].chomp(')')
      expected_love_count.should == actual_love_count
    end

    it 'Verify user see text "Shopping bag"' do
      go_to_BTB_page
      page.should have_xpath("//a[@id = 'mc-header-shopping-bag' and text() = 'SHOPPING BAG']")
    end

    it 'Verify user see correct shopping bag count.' do
      add_product_into_shopping_bag
      go_to_BTB_page
      page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
      expected_count = page.find(:xpath, "//em[@class = 'item_count']").text
      go_to_BTB_page
      a_var = page.find(:xpath, "//a[@id = 'mc-header-cart-count']").text
      actual_count = a_var[2..-1].chomp(' )')
      expected_count.should == actual_count
      remove_product_from_shopping_bag
    end

    it 'Verify user see "Checkout" button' do
      add_product_into_shopping_bag
      go_to_BTB_page
      page.should have_xpath("//a[@id = 'mc-header-checkout-button' and text() = 'CHECKOUT']")
      remove_product_from_shopping_bag
    end

    it 'Verify when user clicks on "Checkout" button then user see checkout flow' do
      puts "PENDING"
    end

    it 'Verify user see "Search" text box with text "Search"' do
      go_to_BTB_page
      page.should have_xpath("//input[@id = 'mc-header-keyword' and @placeholder = 'Search']")
    end
  end

  context 'Search functionality' do
    it 'Valid case' do
      page.find(:xpath, "//a[@href = '/be-the-buyer/available-now']").click
      get_product = page.evaluate_script('$(".product_list li:eq(0) p").text()').to_s
      if (get_product == '')
        fail "No product found for Search test cases."
      else
        go_to_BTB_page
        fill_in 'mc-header-keyword', :with => get_product.strip
        wait_for_script
        click_button('GO')
        wait_for_script
        page.should have_xpath("//div[@id = 'page_title']/h1")
        page.find(:xpath, "//p[@class = 'title']").text().should == get_product.strip
      end
    end

    it 'Invalid case - with blank search' do
      go_to_BTB_page
      fill_in 'mc-header-keyword', :with => ''
      wait_for_script
      click_button('GO')
      wait_for_script
      page.should have_xpath("//div[@class = 'header']")
      page.find(:xpath, "//div[@class = 'message']").text().should == "Search term must be at least 3 characters in length"
    end

    it 'Invalid case - with no result found' do
      go_to_BTB_page
      search_text = 'Ffhkjdhfgkhdfgkjdfhgkjhdfkjfhgkj'.strip
      fill_in 'mc-header-keyword', :with => search_text
      wait_for_script
      click_button('GO')
      wait_for_script
      page.should have_xpath("//div[@id = 'page_title']/h1")
      expected = 'Sorry, no results found for '+'"'+search_text+'"'+'. Please try another search'
      page.find(:xpath, "//div[@class = 'search-no-results']").text().should == expected
    end
  end
end

#describe "Tablet header" do
#  context "Logged out user" do
#      before(:all) do
#        go_to_BTB_page
#        wait_for_script
#      end
#      it 'Verify user see "Curstomer Care" link.' do
#        within ('#mc-header-links') do
#          page.should have_link('Customer Care')
#        end
#      end
#
#      it 'Verify when user clicks on "Customer Care" link it opens correct window' do
#        puts "PENDING TEST CASE"
#      end
#
#      it 'Verify user see Join link' do
#        page.should have_xpath("//a[@id = 'mc-header-join' and @href = '#' and text() = 'Join']")
#      end
#
#      it 'Verify user see Sign in link' do
#        page.should have_xpath("//a[@id = 'mc-header-sign-in' and @href = '#' and text() = 'Sign In']")
#      end
#
#      it 'Verify user see "Search" text box with text "Search"' do
#        go_to_BTB_page
#        page.should have_xpath("//input[@id = 'mc-header-keyword' and @placeholder = 'Search']")
#      end
#
#      it 'Verify user see text "Shopping bag"' do
#        go_to_BTB_page
#        page.should have_xpath("//a[@id = 'mc-header-shopping-bag' and text() = 'SHOPPING BAG']")
#      end
#
#      it 'Verify when user clicks on "Shopping bag" link then user navigates to correct link' do
#        page.find(:xpath, "//a[@id = 'mc-header-shopping-bag']").click
#        page.should have_xpath("//h2[@id = 'shopping-bag-header']/strong[text() = 'Your Shopping Bag is Empty']") #need to add xpath
#      end
#
#      it 'Verify "Search" functionality' do
#
#      end
#
#      it 'Verify "Join" functionality' do
#        go_to_BTB_page
#        join() #Call this function from common helper
#      end
#    end
#end






