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

def get_voting_in_progress_SampleDetails
  connection(:query_name => :Voting_in_progress_SampleDetails, :database_name => :btb)
end

def get_voting_in_progress_SampleCount
  connection({:query_name => :Voting_in_progress_SampleCount, :database_name => :btb})
end

def get_voting_in_progress_CommentCount
  connection({:query_name => :Voting_in_progress_CommentCount})
end
