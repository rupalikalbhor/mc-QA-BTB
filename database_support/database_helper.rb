require 'postgres'
require 'capybara_support/configuration'

def connection()
  get_environment()
  @port_number = 5432
  conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

  puts "ip address is #{@ip_address}"

  #res = conn.exec('select count(*) from social_profiles')
  sql = query_result(@database_name, :out_of_stock)
  res = conn.exec(sql)

  res.each do |row|
    row.each do |column|
      puts column
    end
  end

  conn.close()
end

private
def get_environment()
  env = $environment           #Global variable from configuration file
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
def query_result(database_name, product_state)
  case product_state
    when :out_of_stock
      sql = out_of_stock(database_name)

    else
      print "\n No matching query..Please check you typos.... \n"
      sql = nil
  end
  return sql
end

private
def out_of_stock(database_name)
   #sql = 'select count(*) from comments'
   sql = "SELECT id, commentable_id, commentable_type, reply_to_comment_id, account_id,
          content, status, agreement_count, flag_count, created_at, updated_at,
          legacy_id, commentable_name, commentable_url, account_firstname,
          account_lastname, account_email
     FROM comments where account_email != 'qa@modcloth.com'
     AND status = 'active'
     AND agreement_count = 0 limit 1;"
  return sql
end

