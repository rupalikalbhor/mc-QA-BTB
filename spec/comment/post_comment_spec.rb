require 'support/post_comment'
require 'support/common_helper'

describe 'Posting comment on a sample for a logged-in user' do
  before(:each) do
    go_to_BTB_page
    go_to_SDP_page
  end

  context "UI"
    it '1. Verify the text "Comments" is visible above the comments text-box', :type => :request do
      verify_comment_text
    end

    it '2. Verify the comment text-box is visible' do
      verify_comment_text_box
    end

    it '3. Verify when user clicks inside the text-box, the "Comment" button is visible and still disabled' do
    end

    it '4. Verify when user clicks inside the text-box, the tooltip becomes visible with valid text' do
    end

    it '5. Verify after user types at least one character, the comment button gets enabled' do
    end

  context "No voting"

    it '1. Verify user is able to submit a valid comment' do

    end
    it '2. Verify after page refresh the comment is retained and comment count increments by 1' do
    end

    it '3. Verify user does not see "Agree" link on her own comment' do
    end

    it '4. Verify user does not see "Reply" link on her own comment' do
    end

    it '5. Verify user should not see "Flag" button on her own comment' do
    end

    it '6. Verify user should see her name next to her own comment' do
    end

    it '7. Verify user should see time of post on her own comment' do
    end

    it '8. Verify the voting status appears as blank' do
    end

  context "Pick"
    it '1. Verify user is able to submit a valid comment by selecting vote as "Pick"' do
    end

    it '2. Verify the voting status appears as "Picked"' do
    end

  context "Skip"
    it '1. Verify user is able to submit a valid comment by selecting vote as "Skip"' do
    end

    it '2. Verify the voting status appears as "Skipped"' do
    end

  context "Blocked words"
    it '1. Verify when user enters a comment with blocked word and refresh the page, the comment disappears from the page' do
    end
  context "Invalid"
    it '1. Verify when user enters more than 1000 characters, warning message appears and "Comment" button disappears' do

    end
end