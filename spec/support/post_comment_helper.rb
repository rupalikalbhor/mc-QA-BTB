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

