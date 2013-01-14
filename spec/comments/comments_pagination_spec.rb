#require 'spec/support/common_helper'
#require 'spec/support/query_helper'
require "spec/spec_helper"

describe 'I. Comments - Comments_pagination_spec', :no_phone => true do
  before(:all) do
    go_to_BTB_page
  end

  it '1. Go to sample detail page which has comments.' do
    go_to_SDP_with_comments()
  end

  it '2. Verify top pagination displays correct results' do
    commentable_name = page.find(:xpath, "//div[@class = 'sample']/div[@class = 'name']", :visible => true).text
    Comment_count = get_comment_count(commentable_name)
    if (Comment_count.to_i > 30)
      page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing 1 - 30 of '+Comment_count+ ' Comments')
    else
      page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +Comment_count+ ' Comments')
    end
  end

  #it '. Verify bottom pagination displays correct results' do
  #  comment_count = page.body.match(/of (\d+)/)[1]
  #  if (comment_count.to_i > 30)
  #    page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing 1 - 30 of '+comment_count+ ' comments')
  #  else
  #    page.find(:xpath, "//p[@class = 'comment-results'][2]").text.should eq('Showing All ' +comment_count+ ' Comments')
  #  end
  #end

  #it '3. Verify top pagination matches bottom comment pagination' do
  #  page.find(:xpath, "//p[@class = 'comment-results']").text.should eq(page.find(:xpath, "(//p[@class = 'comment-results'])[2]").text)
  #end

  #it '4. Verify Show X More button displays.' do
  #  #comment_count = page.body.match(/of (\d+)/)[1]
  #  if (Comment_count.to_i > 30)
  #    page.find(:xpath, '//div[@class = "show-more"]', :visible => true).text.should eq('Show 30 More')
  #  else
  #    page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +Comment_count+ ' Comments')
  #  end
  #end

  it '5. Verify when user clicks on "Show 30 More" button, it displays 30 more records and pagination text updates correctly.' do
    go_to_BTB_page
    commentable_name = go_to_SDP_with_comments_greater_than_30()
    if (commentable_name != nil)
      total_comment_count = get_comment_count(commentable_name)
      current_page_records = 30
      if (total_comment_count.to_i > 30)
        begin
          current_comment_count = page.body.match(/Show (\d+)/)[1]
          page.find(:xpath, '//div[@class = "show-more"]').click
          current_page_records = current_comment_count.to_i + current_page_records
          if (current_page_records.to_i != total_comment_count.to_i)
            page.find(:xpath, "//div[@class = 'pagination']").text.should eq('Showing 1 - '+current_page_records.to_s+ ' of '+total_comment_count+ ' Comments')
          else
            page.find(:xpath, "//div[@class = 'pagination']").text.should eq('Showing All ' +total_comment_count+ ' Comments')
          end
        end while (current_page_records != total_comment_count.to_i)
      else
        page.find(:xpath, "//div[@class = 'pagination']").text.should eq('Showing All ' +total_comment_count+ ' Comments')
      end
    else
      fail "There are no samples which has more than 30 comments.."
    end

  end

  it '6. Verify "Show x More" button text updates correctly.' do
    go_to_BTB_page
    commentable_name = go_to_SDP_with_comments_greater_than_30()
    if (commentable_name != nil)
      total_comment_count = get_comment_count(commentable_name)
      current_page_records = 30
      if (total_comment_count.to_i > 30)
        begin
          current_comment_count = page.body.match(/Show (\d+)/)[1]
          if (current_comment_count.to_i == 30)
            page.find(:xpath, "//div[@class = 'show-more']").text.should eq('Show 30 More')
          else
            page.find(:xpath, "//div[@class = 'show-more']").text.should eq('Show '+current_comment_count+' More')
          end
          page.find(:xpath, '//div[@class = "show-more"]').click
          current_page_records = current_comment_count.to_i + current_page_records
        end while (current_page_records != total_comment_count.to_i)
      else
        page.find(:xpath, "//div[@class = 'pagination']").text.should eq('Showing All ' +total_comment_count+ ' Comments')
      end
    else
      fail "There are no samples which has more than 30 comments.."
    end
  end
end

describe 'II. Pagination for phone comments page', :no_desktop => true, :no_tablet => true do
  before(:all) do
    go_to_BTB_page
  end

  it '1. Go to sample detail page which has comments.' do
    commentable_name = go_to_SDP_with_comments()
    Phone_comment_count = get_comment_count(commentable_name)
  end

  it '2. Verify top pagination displays correct results' do
    #comment_count = page.body.match(/of (\d+)/)[1]
    page.find(:xpath, "//div[@class = 'comment-section collapses collapsed']/h2", :visible => true).click
    if (Phone_comment_count.to_i > 3)
      page.find(:xpath, '//div[@class = "pagination"]', :visible => true).text.should eq('Showing 1 - 3 of '+Phone_comment_count+ ' Comments')
    else
      page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +Phone_comment_count+ ' Comments')
    end
  end


  it '4. Verify Show X More button displays.' do
    go_to_BTB_page
    commentable_name = go_to_SDP_with_comments_greater_than_3()
    wait_for_script
    total_comment_count = get_comment_count(commentable_name)
    page.find(:xpath, "//div[@class = 'comment-section collapses collapsed']/h2", :visible => true).click
    if (total_comment_count.to_i > 3)
        page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing 1 - 3 of '+total_comment_count+ ' Comments')
    else
      page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +total_comment_count+ ' Comments')
    end
  end

  it '5. Verify when user clicks on "Show 3 More" button, it displays 3 more records and pagination text updates correctly.' do
    go_to_BTB_page
    commentable_name = go_to_SDP_with_comments_greater_than_3()
    if (commentable_name != nil)
      total_comment_count = get_comment_count(commentable_name)
      page.find(:xpath, "//div[@class = 'comment-section collapses collapsed']/h2", :visible => true).click
      current_page_records = 3
      if (total_comment_count.to_i > 3)
        begin
          current_comment_count = page.body.match(/Show (\d+)/)[1]
          page.find(:xpath, '//div[@class = "show-more"]', :visible => true).click
          wait_for_script
          current_page_records = current_comment_count.to_i + current_page_records
          if (current_page_records.to_i != total_comment_count.to_i)
            page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing 1 - '+current_page_records.to_s+ ' of '+total_comment_count+ ' Comments')
          else
            page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +total_comment_count+ ' Comments')
          end
        end while (current_page_records != total_comment_count.to_i)
      else
        page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +total_comment_count+ ' Comments')
      end
    else
      fail "There are no samples which has more than 3 comments.."
    end
  end

  it '6. Verify "Show x More" button text updates correctly.' do
    go_to_BTB_page
    commentable_name = go_to_SDP_with_comments_greater_than_3()
    if (commentable_name != nil)
      total_comment_count = get_comment_count(commentable_name)
      page.find(:xpath, "//div[@class = 'comment-section collapses collapsed']/h2", :visible => true).click
      current_page_records = 3
      if (total_comment_count.to_i > 3)
        begin
          current_comment_count = page.body.match(/Show (\d+)/)[1]
          if (current_comment_count.to_i == 3)
            page.find(:xpath, "//div[@class = 'show-more']", :visible => true).text.should eq('Show 3 More')
          else
            page.find(:xpath, "//div[@class = 'show-more']", :visible => true).text.should eq('Show '+current_comment_count+' More')
          end
          page.find(:xpath, '//div[@class = "show-more"]', :visible => true).click
          wait_for_script
          current_page_records = current_comment_count.to_i + current_page_records
        end while (current_page_records != total_comment_count.to_i)
      else
        page.find(:xpath, "//div[@class = 'pagination']", :visible => true).text.should eq('Showing All ' +total_comment_count+ ' Comments')
      end
    else
      fail "There are no samples which has more than 3 comments.."
    end
  end
end

def go_to_SDP_with_comments()
  sample_count = get_voting_in_progress_SampleCount()
  i = 1
  if (sample_count.to_i !=0)
    begin
      comment_count = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'counters']/div[@class = 'comments-count']", :visible => true).text
      if (comment_count.to_i > 0)
        sample_name = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'name']", :visible => true).text
        page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a", :visible => true).click
        wait_for_script
        break
      else
        i = i+1
      end
    end while (i != sample_count.to_i - 1)
  else
    fail "There are no samples in Voting in progress tab.."
  end
  return sample_name
end

def go_to_SDP_with_comments_greater_than_30()
  sample_count = get_voting_in_progress_SampleCount()
  i = 1
  if (sample_count.to_i !=0)
    begin
      comment_count = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'counters']/div[@class = 'comments-count']", :visible => true).text
      if (comment_count.to_i > 30)
        sample_name = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'name']", :visible => true).text
        page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a", :visible => true).click
        wait_for_script
        break
      else
        i = i+1
      end
    end while (i != sample_count.to_i - 1)
  else
    fail "There are no samples in Voting in progress tab.."
  end
  return sample_name
end

def go_to_SDP_with_comments_greater_than_3()
  sample_count = get_voting_in_progress_SampleCount()
  i = 1
  if (sample_count.to_i !=0)
    begin
      comment_count = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'counters']/div[@class = 'comments-count']", :visible => true).text
      if (comment_count.to_i > 3)
        sample_name = page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'name']", :visible => true).text
        page.find(:xpath, "//div[@class = 'sample']["+i.to_s+"]/div/div[@class = 'photo']/a", :visible => true).click
        wait_for_script
        break
      else
        i = i+1
      end
    end while (i != sample_count.to_i - 1)
  else
    fail "There are no samples in Voting in progress tab.."
  end
  return sample_name
end
