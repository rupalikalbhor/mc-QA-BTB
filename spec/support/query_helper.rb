require 'database_support/database_helper'

#Get Sample detail page method
def get_SDP_page_non_login_user
  connection(:SDP, '')
end

def get_SDP_page_login_user
  connection(:SDP_loginuser, '')
end

def get_comment_id(sample_id)
  connection(:comment_with_no_agree, sample_id)
end

def get_comment_id_for_login_user()
  connection(:commentid_for_login_user, sample_id)
end