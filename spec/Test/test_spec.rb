require 'spec/spec_helper'
require 'database_support/database_helper'
require 'support/common_helper'
require 'support/query_helper'

describe 'Testing' do
  it 'Visit to homepage.', :type => :request do
    tt
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