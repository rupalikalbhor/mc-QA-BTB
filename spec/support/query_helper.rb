require 'database_support/database_helper'

#Get Sample detail page method
def go_to_SDP
  puts "Before url is"
  url = connection({:query_name => :SDP})
  puts "Url is - #{url}"
  visit url
end

#Delete comments which are written by user 'qa@modcloth.com'
def delete_comment
  connection(:query_name => :DeleteComments)
end
