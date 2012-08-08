require 'postgres'
require 'capybara_support/configuration'

def connection()
  get_environment()
  @port_number = 5432
  @conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

  puts "ip address is #{@ip_address}"

  sql = query_result(@database_name, :SDP)
  if sql.nil?
    return ""
  end
  query_resultset = @conn.exec(sql)
  output = result_set(:SDP, query_resultset)
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
def query_result(database_name, query_name)
  case query_name
    when :SDP
      sql = select_Commentableid_Comquerymentablename_from_comments()
    else
      print "\n No matching query..Please check you typos.... \n"
      sql = nil
  end
  return sql
end

private
def select_Commentableid_Comquerymentablename_from_comments()
  sql = "SELECT commentable_id, commentable_name
     FROM comments where account_email != 'qa@modcloth.com'
     AND status = 'active'
     AND agreement_count = 0 limit 1;"
  return sql
end

def result_set(query_name, res)
  case query_name
    when :SDP
      commentable_id = res.getvalue(0, 0)
      commentable_name = res.getvalue(0, 1)
      @url = @url + '/' + commentable_id+'-sample-'+ commentable_name
      return @url
    else
      value = res.getvalue(0, 0)
      return value
  end
end
