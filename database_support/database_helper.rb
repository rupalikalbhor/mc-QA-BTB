require 'postgres'
require 'capybara_support/configuration'

def connection()
  get_environment()
  @port_number = 5432
  @conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

  puts "ip address is #{@ip_address}"

  #res = conn.exec('select count(*) from social_profiles')
  sql = query_result(@database_name, :SDP)
  result_set(:SDP, sql)
  @conn.close()
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
end

private
def select_Commentableid_Comquerymentablename_from_comments()
  sql = "SELECT commentable_id, commentable_name
     FROM comments where account_email != 'qa@modcloth.com'
     AND status = 'active'
     AND agreement_count = 0 limit 1;"
end

def result_set(query_name, sql)
  res = @conn.exec(sql)
  case query_name
    when :SDP
      res.each(:as => :array) do |row|
        puts #{row[0]}
        commentable_id = row[0]
        commentable_name = row[1]
        @url = @url + commentable_id+'-sample-'+ commentable_name
        puts(@url)
      end
    else
      res.each do |row|
        row.each do |column|
          puts column
        end
      end
  end
end
