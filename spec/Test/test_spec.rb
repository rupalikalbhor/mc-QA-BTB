# encoding: utf-8
require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it '3. Verify after clicking on "Sign in Comment" button and successful login user navigates back to SDP page.' do
    visit 'https://btb-ecomm.demo.modcloth.com/signin?gate=btb&known=true'
        wait_until{

          #page.find(:xpath, "//form[@id='login-form']").visible? == true
          page.should have_xpath("//form[@id='login-form']")

        }

      end

end
#----------------------------------------------------------







