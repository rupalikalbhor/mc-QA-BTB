require 'database_support/database_helper'

#This function will give you all the details for sample for given sample id.
def get_sample_details(first_sample_id)
  connection(:query_name => :SampleDetails, :database_name => :btb, :product_id => first_sample_id)
end

def get_voting_in_progress_SampleCount
  connection({:query_name => :Voting_in_progress_SampleCount, :database_name => :btb})
end

#This function will return comment count
# commentable_name = Sample 1234
def get_comment_count(commentable_name)
  connection({:query_name => :CommentCount, :commentable_name => commentable_name})
end

def get_awaiting_results_SampleCount
  connection({:query_name => :Awaiting_results_SampleCount, :database_name => :btb})
end

def get_in_production_SampleCount
  connection({:query_name => :In_Production_SampleCount, :database_name => :btb})
end

def get_product_id_for_skipped_sample
  connection({:query_name => :Skipped_sample, :database_name => :btb})
end

