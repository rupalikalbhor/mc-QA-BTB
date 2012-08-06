require 'spec_helper'

def verify_comment_text
  within ('#comment-view') do
    page.should have_content ("Comments")
  end
end

def verify_comment_text_box
  within ('#comment-view .new-comment')do
  page.find('.content').should be_visible
  end
end

