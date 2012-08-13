require 'postgres'
require 'capybara_support/configuration'

def connection(options)
  query_name = options[:query_name] || :SDP
  sample_id = options[:sample_id] || :sample_id
  user_email = options[:user_email] || $user_email

  get_environment()
  @port_number = 5432
  @conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

  sql = query_collection(query_name, sample_id)
  if sql.nil?
    return ""
  end

  result_set = @conn.exec(sql)
  output = query_result(query_name, result_set)
  @conn.close()
  return output
end

private
def get_environment()
  env = $environment #Global variable from configuration file
  case env
    when :stage
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"

    when :production
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"

    when :preview
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"

    when :demo
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"
  end
  @url = CapybaraSupport::Configuration.get_environment_url
end

private
def query_collection(query_name, sample_id)
  case query_name
    when :SDP
     sql = "SELECT commentable_id, commentable_name, id
     FROM comments where account_email !=" + "'" + $email + "'" + "
     AND status = 'active'
     AND agreement_count = 0 order by id desc limit 1;"

    when :SDP_loginuser
      sql = select_commentableId_commentableName_for_loginuser()

    when :commentid_for_login_user
      sql = select_commentableId_from_comments_loginuser(sample_id)

    when :comment_with_agree
      sql = select_commentableId_commentableName_agreementCount_from_comments()
    else
      print "\n No matching query..Please check your typos.... \n"
      sql = nil
  end
  return sql
end

private
def select_commentableId_from_comments(sample_id)
  sql = "SELECT max(id)
       FROM comments where account_email !="+ "'" + $email + "'" + "
       AND status = 'active'
       AND commentable_name =" + "'" + 'sample_id' + "'" + "
       AND agreement_count = 0;"
  return sql
end

private
def select_commentableId_commentableName_for_loginuser()
  sql = "SELECT commentable_id, commentable_name
     FROM comments where account_email = "+ "'" + $email + "'" + "
     AND status = 'active' limit 1;"
  return sql
end

private
def select_commentableId_from_comments_loginuser(sample_id)
  sql = "SELECT max(id)
         FROM comments where account_email = "+ "'" + $email + "'" + "
         AND status = 'active'
         AND commentable_name =" +"'"+sample_id+"'"+ ";"
  return sql
end

private
def select_commentableId_commentableName_agreementCount_from_comments
  sql = "SELECT commentable_id, commentable_name, agreement_count
         FROM comments where account_email = "+ "'" + $email + "'" + "
         AND agreement_count > 0
         AND status = 'active' limit 1;"
  return sql
end

private
def query_result(query_name, res)
  case query_name
    when :SDP
      commentable_id = res.getvalue(0, 0)
      commentable_name = res.getvalue(0, 1)
      $comment_id = res.getvalue(0, 2)
      puts "Comment id is: #{$comment_id}"
      @url = @url + '/' + commentable_id+'-sample-'+ commentable_name
      puts @url
      return @url

    when :SDP_loginuser
      commentable_id = res.getvalue(0, 0)
      commentable_name = res.getvalue(0, 1)
      @url = @url + '/' + commentable_id+'-sample-'+ commentable_name
      puts @url
      return @url

    when :comment_with_agree
      commentable_id = res.getvalue(0, 0)
      commentable_name = res.getvalue(0, 1)
      $agreement_count = res.getvalue(0, 2)

      @url = @url + '/' + commentable_id+'-sample-'+ commentable_name
      puts @url
      return @url

    else
      value = res.getvalue(0, 0)
      return value
  end
end
