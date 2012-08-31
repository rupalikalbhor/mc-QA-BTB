require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it 'Visit to homepage.', :type => :request do
    visit 'http://btb.demo.modcloth.com/be-the-buyer/voting-in-progress'
    var = page.find(:xpath, "//div[@class='sample-grid']/div[@class='sample'][2]/div[@data-product-id]").text
    puts " Value is ******:#{var}"

    #tt
  end

  it 'Verify sample number is displaying correctly' do

        FIRST_SAMPLE_PRODUCT_ID = page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
        #get_first_sample_product_id(first_sample_product_id)

        #@@first_sample_product_id = page.evaluate_script("$('.sample-data').attr('data-product-id')").to_s
        #get_voting_in_progress_SampleDetails(@@first_sample_product_id)
        expected_sample_name = FIRST_SAMPLE_PRODUCT_ID
        page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class='name']").text.should == expected_sample_name
        #page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class='name']").text.should == expected_sample_name

      end

      it 'Verify pin icon is displaying in sample box' do
        puts "First sample is... #{FIRST_SAMPLE_PRODUCT_ID}"
        page.find(:xpath, "//div[@data-product-id="+FIRST_SAMPLE_PRODUCT_ID+"]/div[@class = 'pin']")
        #page.find(:xpath, "//div[@data-product-id="+@@first_sample_product_id+"]/div[@class = 'pin']")
      end
end

def tt
  expected_voting_time = "3 days 00:32:00"
  strlength = expected_voting_time.length
    days = expected_voting_time[0, 1]+"d"+" "
    if (strlength > 8)
      hours = expected_voting_time[7, 2]
      if (hours != "00")
        hours_first_number = hours[0, 1]

        if (hours_first_number == '0')
          hours = hours[1, 2]+"h"
        else
          hours+"h"
        end
        voting_days = days + hours

      else
        voting_days = days
      end
    else
      hours = expected_voting_time[0, 2]
      if (hours != "00")
        hours_first_number = hours[0, 1]

        if (hours_first_number == '0')
          hours = hours[1, 2]+"h"
        else
          hours = hours+"h"
        end
        voting_days = hours
      else
        minutes = expected_voting_time[3, 2]
        minutes_first_number = minutes[0, 1]
        if (minutes_first_number == '0')
          minutes = minutes[1, 1]+"m"
        else
          minutes = minutes+"m"
        end
        voting_days = minutes
      end
    end
  puts "Voting days are*******************: #{voting_days}"
end