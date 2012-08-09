require 'support/query_helper'

def verify_agree_on_comment
  sample_id = page.driver.browser.current_url.split("-").last
  comment_id = get_comment_id((sample_id).to_s)
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/a").click
  page.driver.browser.navigate.refresh
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/a").text.should eq('You Agree')
end

def verify_agree
  id= page.evaluate_script("$('.comment .agreement a:eq(0)').parent().parent().parent().attr('data-comment-id')").to_s
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").click
  visit page.driver.browser.current_url
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").text.should eq('You Agree')
end

def verify_agree_link
  sample_id = page.driver.browser.current_url.split("-").last
  comment_id = get_comment_id((sample_id).to_s)
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/a").click
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/a").text.should eq('You Agree')
end

def verify_agree_count
  sample_id = page.driver.browser.current_url.split("-").last
  comment_id = get_comment_id((sample_id).to_s)
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/a").click
  find(:xpath, "//div[@data-comment-id=#{comment_id}]/div/span/span").text.should eq('1')
end

def verify_no_agree_link
  sample_id = page.driver.browser.current_url.split("-").last
  comment_id = get_comment_id((sample_id).to_s)
  within('#'+comment_id) do
    page.should have_no_link('Agree')
  end
end
