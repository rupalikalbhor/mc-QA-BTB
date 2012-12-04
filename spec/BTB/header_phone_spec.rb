require 'spec/support/common_helper'

describe 'Phone Header' do
  before(:all) do
    go_to_BTB_page
    wait_for_script
    click_sign_in_link
    sign_in
  end
  context 'UI' do

    it 'Verify clicking on modcloth logo loads modcloth home page.' do
      page.find(:xpath, "//div[@class = 'logo']").click
      wait_for_script
      page.should have_selector(:xpath, "//a[@id = 'logo']")
      go_to_BTB_page
    end

    it 'Verify clicking on BTB logo loads Be The Buyer page.' do
      page.find(:xpath, "//div[@id = 'btb-logo']").click
      wait_for_script
      page.should have_content('Voting In Progress')
    end

    it "Verify user see text 'Showing' with drop down option displays following options with correct text & icon -
      - Voting in Progress
      - Awaiting Results
      - In Production
      - Avaialble Now" do
      page.find(:xpath, "//div[@id='menu-toggle']").click
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/voting-in-progress']/li/div").text.should == "Voting In Progress"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/awaiting-results']/li/div").text.should == "Awaiting Results"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/in-production']/li/div").text.should == "In Production"
      page.find(:xpath, "//ul[@id = 'menu-options']/a[@href = '/be-the-buyer/available-now']/li/div").text.should == "Available Now"
    end


    it "Verify when user clicks on 'MENU' option then all category links gets displayed." do
      page.find(:xpath, "//div[@id = 'mc-header-menu-toggle']").click
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

    it 'Verify user see Search text box with submit button.' do
      page.should have_xpath("//input[@id = 'mc-header-keyword']")
      page.should have_xpath("//input[@id = 'mc-header-search-button']")
    end

    it 'Verify user see shopping bag with count 0' do
      page.should have_xpath("//a[@id = 'mc-phone-header-bag']")
      page.find(:xpath, "//a[@id = 'mc-phone-header-bag']").text.should == "0"
    end

    #it 'Verify user see Join or Sign in link' do
    #  page.should have_xpath("//a[@id = 'mc-phone-header-join']")
    #  page.find(:xpath, "//a[@id = 'mc-phone-header-join']").text.should == "Join or Sign In"
    #end

    it 'Verify Menu links are working correctly.' do
      menu_count = 1
      begin
        page.find(:xpath, "//div[@id = 'mc-header-menu-toggle']").click
        page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a["+menu_count.to_s+"]/li").click
        wait_for_script
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
        wait_for_script
        menu_count = menu_count + 1
      end while (menu_count != 10)
    end

    it 'Verify when user clicks on Shopping bag icon, user navigates to shopping bag page.' do
      page.find(:xpath, "//a[@id = 'mc-phone-header-bag']").click
      wait_for_script
      page.find(:xpath, "//h1[@id = 'category-header']/span").text.should == "Shopping Bag"
      go_to_BTB_page
      wait_for_script
    end

    # Bug
    #it 'Verify when user clicks on "Be the buyer" text then user navigates to BTB homepage.' do
    #  page.find(:xpath, "//div[@id = 'mc-header-menu-toggle']").click
    #  page.find(:xpath, "//div[@id = 'mc-header-menu-dropdown']/ul/a[@href = '/storefront/products/be_the_buyer']").click
    #  wait_for_script
    #  page.should have_xpath("//div[@id = 'btb-logo']")
    #end

    after(:all) do
      go_to_BTB_page
      wait_for_script
      sign_out
    end
  end

  context "Functional Tests" do
    before(:all) do
      go_to_BTB_page
      wait_for_script
      click_sign_in_link
      sign_in
    end

    before(:each) do
      go_to_BTB_page
      wait_for_script
    end

    it 'Verify when user clicks on username then user see following options -
            Wishlist
            Order history
            Loved items
            Sign out' do

      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a").click
      wait_for_script
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/wishlists']").text.should == "WISHLISTS"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/customers/orders']").text.should == "ORDER HISTORY"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/lovelists/show']").text.should == "LOVED ITEMS"
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/logout']").text.should == "SIGN OUT"
    end

    it 'Verify when user clicks on Wishlist then user navigates to wishlist page' do
      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a").click
      wait_for_script
      page.find(:xpath, "//nav[@id = 'signed-in-menu']/div/a[@href = '/storefront/wishlists']").click
      wait_for_script
      page.find(:xpath, "//div[@id = 'mobile-wishlists']/h1").text.should == "Wishlists"
    end

    it 'Verify when user clicks on Order History then user navigates to Order History page' do
      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/customers/orders']").click
      wait_for_script
      page.find(:xpath, "//div[@id = 'mobile-order-history-header']/h1").text.should == "Order History"
    end

    it 'Verify when user clicks on Loved Items then user navigates to Loved Items page' do
      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/storefront/lovelists/show']").click
      wait_for_script
      page.find(:xpath, "//h1[@id = 'category-header']").text.should == "My Loved Items"
    end

    it 'Verify when user clicks on Sign out option then user gets signed out and user remains on same page.' do
      page.find(:xpath, "//div[@id = 'mc-phone-header-welcome']/a").click
      wait_for_script
      page.find(:xpath, "//a[@href = '/logout']").click
      wait_for_script
      page.should have_selector(:xpath, "//div[@id = 'btb-logo']")
    end
  end

  context 'Search' do
    before(:each) do
      go_to_BTB_page
      wait_for_script
    end
    it 'Valid case' do
      go_to_available_now_page
      get_product = page.evaluate_script('$("#product-grid li:eq(0) p").text()').to_s
      puts "Prdouct is: #{get_product}"
      if (get_product == '')
        fail "No product found for Search test cases."
      else
        go_to_BTB_page
        fill_in 'mc-header-keyword', :with => get_product.strip
        wait_for_script
        click_button('GO')
        wait_for_script
        page.find(:xpath, "//p[@class = 'title']").text().should == get_product.strip
      end
    end

    it 'Invalid case - with blank search' do
      fill_in 'mc-header-keyword', :with => ''
      wait_for_script
      click_button('GO')
      wait_for_script
      page.should have_xpath("//div[@id = 'header']/a[@id = 'logo']")
    end

    it 'Invalid case - with no result found' do
      search_text = 'Ffhkjdhfgkhdfgkjdfhgkjhdfkjfhgkj'.strip
      fill_in 'mc-header-keyword', :with => search_text
      wait_for_script
      click_button('GO')
      wait_for_script
      page.find(:xpath, "//h1[@id = 'category-header']/span").text.should == "\""+search_text+"\""
      page.find(:xpath, "//div[@id = 'no-results-block']/p").text.should == "Sorry, no results were found."
      page.find(:xpath, "//div[@id = 'no-results-block']/p[@class = 'try-again']").text.should == "Please try another search."
    end
  end

  context "Facebook Sign in" do
    it 'Verify after successful facebook sign in user navigates to BTB homepage' do
      go_to_BTB_page
      wait_for_script
      click_sign_in_link
      sign_in_with_facebook()
    end
  end
end

