require 'support/shared_example_BTB'

describe 'voting in progress page' do

  #before { visit path }
  before(:all) do
      go_to_BTB_page
      wait_for_script
    end

  it 'is accessible' do
    visit root_path
    click_link page_title
    page.current_path.should == path
  end

  it 'has breadcrumbs' do
    page.find('#breadcrumbs').should satisfy do |breadcrumb|
      breadcrumb.find('a:first').text.should == 'ModCloth'
      breadcrumb.find('a:first')['href'].should =~ /modcloth\.com/

      breadcrumb.find('a:last').text.should == 'Be The Buyer'
      breadcrumb.find('a:last')['href'].should == root_path

      breadcrumb.text.should include page_title
    end
  end

  context 'displays navigation bar' do
    subject { page.find('.navigation')}

    it 'includes the title' do
      subject.find('.title').should have_content page_title
    end

    it "includes pagination summary" do
      subject.find('.pagination').should have_content "Showing 1 - 1 of 1"
    end

  end

  context 'displays sample box', js: true do
    subject { page.find("div[data-product-id='#{sample.id}']") }

    it_behaves_like 'a grid-view sample'

    it 'includes voting buttons' do
      subject.should have_link "Pick"
      subject.should have_link "Skip"
    end

    it 'includes time left' do
      subject.find('.time-remaining').should have_content "6d 23h"
    end
  end
end