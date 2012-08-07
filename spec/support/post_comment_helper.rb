require 'spec_helper'

def verify_comment_text
  within ('#comment-view') do
    page.should have_content ("Comments")
  end
end

def verify_comment_text_box
  within ('#comment-view .new-comment') do
    page.find(:xpath, "//textarea[@name='new-comment-text']").visible?.should eq(true)
  end
end

def verify_comment_button_visible
  within ('#comment-view .new-comment') do
    page.find(:xpath, "//textarea[@name='new-comment-text']").click
    page.find(:xpath, "//input[@type='submit']").visible?.should eq (true)
    page.find(:xpath, "//input[@type='submit']")['disabled'].should eq("true")
  end
end

def verify_comment_button_enabled
  within ('#comment-view .new-comment') do
    page.find(:xpath, "//textarea[@name='new-comment-text']").click
    fill_in 'new-comment-text', :with => 'A'
    page.find("input[@type='submit']").visible?.should eq (true)
    page.find("input[@type='submit']")['disabled'].should eq(nil)
  end
end

def verify_tooltip
  find(:xpath, "//textarea[@name='new-comment-text']").click
  within ('#comment-view .new-comment') do
    find(:xpath, "//span[@style='display: block;']").text.should eq('Be polite! Is your comment constructive?')
    page.should have_content('Be polite! Is your comment constructive?')
  end
end

def verify_agree
  id= page.evaluate_script("$('.comment .agreement a:eq(0)').parent().parent().parent().attr('data-comment-id')").to_s
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").click
  visit page.driver.browser.current_url
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").text.should eq('You Agree')
end


