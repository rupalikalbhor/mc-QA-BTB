require 'postgres'
require 'capybara_support/configuration'

def connection(options)
  query_name = options[:query_name] || :SDP

  get_environment()
  @port_number = 5432
  @conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

  sql = query_collection(query_name)
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
      @ip_address = ""
      @database_name = ""
      @user_name = ""
      @password = ""

    when :production
      @ip_address = ""
      @database_name = ""
      @user_name = ""
      @password = ""

    when :preview
      @ip_address = ""
      @database_name = ""
      @user_name = ""
      @password = ""

    when :demo
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"
  end
  @url = CapybaraSupport::Configuration.get_environment_url
end

private
def query_collection(query_name)
  case query_name
    when :SDP
     sql = "SELECT commentable_id, commentable_name, id
     FROM comments where account_email !=" + "'" + $email + "'" + "
     AND status = 'active'
     AND agreement_count = 0 order by id desc limit 1;"

    when :DeleteComments
    sql = "delete from comments where account_email =" + "'" + $email + "'" + ""

    else
      print "\n No matching query..Please check your typos.... \n"
      sql = nil
  end
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

    when :DeleteComments
      puts "Comments deleted successfully for user #{$email}"

    else
      value = res.getvalue(0, 0)
      return value
  end
end
