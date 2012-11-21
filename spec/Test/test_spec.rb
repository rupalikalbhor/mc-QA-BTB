# encoding: utf-8
require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it '3. Verify after clicking on "Sign in Comment" button and successful login user navigates back to SDP page.' do
    visit '/'+'be-the-buyer/voting-in-progress?device_type=phone'
    visit 'http://btb-ecomm.demo.modcloth.com/be-the-buyer/samples/66076-sample-2402'
click_sign_in_link()
    sign_in()
          within ('.new-comment') do
            page.find(:xpath, "//textarea[@name='new-comment-text']").click
            @currentDateTime = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
            Long_comment = 'New comment is added by QA1' +@currentDateTime.to_s+ ' New comment is added by QA2, New comment is added by QA3, New comment is added by QA4, New comment is added by QA5, New comment is added by QA6, New comment is added by QA7, New comment is added by QA8, New comment is added by QA9, New comment is added by QA10, New comment is added by QA11, New comment is added by QA12'
            fill_in 'new-comment-text', :with => Long_comment
            page.find("input[@type='submit']").click
            page.driver.browser.navigate.refresh
            if ($device_name == :phone)
              page.find(:xpath, "//div[@id = 'comment-section']/h2").click
              page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div/span/a").click

          end
            page.find(:xpath, "//div[@class = 'comment-list']/ul/li/div/div").text.should eq(Long_comment)
          end
  end
end
#----------------------------------------------------------









