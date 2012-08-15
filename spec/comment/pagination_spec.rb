require 'support/common_helper'
require 'support/query_helper'

describe 'Pagination for comments page' do
  before(:all) do
    go_to_BTB_page
    go_to_SDP
    wait_for_script
  end

  context 'Pagination > 30 comments'
  it '1. Verify top pagination displays correct results' do
    comment_count = page.body.match(/of (\d+)/)[1]
    if (comment_count.to_i > 30)
      page.find(:xpath, "//p[@class = 'comment-results']").text.should eq('Showing 1 - 30 of '+comment_count+ ' comments')
    else
      page.find(:xpath, "//p[@class = 'comment-results']").text.should eq('Showing All ' +comment_count+ ' Comments')
    end
  end

  it '. Verify bottom pagination displays correct results' do
    comment_count = page.body.match(/of (\d+)/)[1]
    if (comment_count.to_i > 30)
      page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing 1 - 30 of '+comment_count+ ' comments')
    else
      page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +comment_count+ ' Comments')
    end
  end

  it '3. Verify top pagination matches bottom comment pagination' do
    page.find(:xpath, "//p[@class = 'comment-results']").text.should eq(page.find(:xpath, "(//p[@class = 'comment-results'])[2]").text)
  end

  it '4. Verify Show X More button displays.' do
    comment_count = page.body.match(/of (\d+)/)[1]
    if (comment_count.to_i > 30)
      page.find(:xpath, '//div[@id = "show-more"]').text.should eq('Show 30 More')
    else
      page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +comment_count+ ' Comments')
    end
  end

  it '5. Verify when user clicks on "Show 30 More" button, it displays 30 more records and pagination text updates correctly.' do
    total_comment_count = page.body.match(/of (\d+)/)[1]
    current_page_records = 30
    if (total_comment_count.to_i > 30)
      begin
        current_comment_count = page.body.match(/Show (\d+)/)[1]
        page.find(:xpath, '//div[@id = "show-more"]').click
        current_page_records = current_comment_count.to_i + current_page_records
        if (current_page_records.to_i != total_comment_count.to_i)
          page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing 1 - '+current_page_records.to_s+' of '+total_comment_count+ ' comments')
        else
          page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +total_comment_count+ ' Comments')
        end
      end while (current_page_records != total_comment_count.to_i)
    else
      page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +total_comment_count+ ' Comments')
    end
  end

  it '6. Verify "Show x More" button text updates correctly.' do
    go_to_SDP
    wait_for_script
    total_comment_count = page.body.match(/of (\d+)/)[1]
    current_page_records = 30
    if (total_comment_count.to_i > 30)
      begin
        current_comment_count = page.body.match(/Show (\d+)/)[1]
        if (current_comment_count.to_i == 30)
          page.find(:xpath, "//div[@id = 'show-more']").text.should eq('Show 30 More')
        else
          page.find(:xpath, "//div[@id = 'show-more']").text.should eq('Show '+current_comment_count+' More')
        end
        page.find(:xpath, '//div[@id = "show-more"]').click
        current_page_records = current_comment_count.to_i + current_page_records
      end while (current_page_records != total_comment_count.to_i)
    else
      page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +total_comment_count+ ' Comments')
    end
  end
end
