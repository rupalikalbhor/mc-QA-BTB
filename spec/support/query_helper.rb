require 'database_support/database_helper'

#Get Sample detail page method
def go_to_SDP
  url = connection({:query_name => :SDP})
  visit url
end

def get_SDP_page_login_user
  connection({:query_name =>:SDP_loginuser})
end

def get_comment_id_for_login_user()
  connection({:query_name =>:commentid_for_login_user})
end

def get_SDP_page_agree
  connection({:query_name => :comment_with_agree})
end
