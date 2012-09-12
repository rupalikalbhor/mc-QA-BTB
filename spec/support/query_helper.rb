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

def get_voting_in_progress_SampleDetails(first_sample_id)
  connection(:query_name => :Voting_in_progress_SampleDetails, :database_name => :btb, :product_id => first_sample_id)
end

def get_voting_in_progress_SampleCount
  connection({:query_name => :Voting_in_progress_SampleCount, :database_name => :btb})
end

def get_voting_in_progress_CommentCount(commentable_name)
  connection({:query_name => :Voting_in_progress_CommentCount, :commentable_name => commentable_name})
end