require 'postgres'
require 'capybara_support/configuration'

def connection()
  get_environment()
  @port_number = 5432
  conn = PGconn.connect(@ip_address, @port_number, '', '', @database_name, @user_name, @password)

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
      @ip_address = "master-db-identity.stage.modcloth.com"
      @database_name = "identity"
      @user_name = "identity"
      @password = "alfjljqreovcab408qewfasdlj"

    when :production
      @ip_address = "192.168.38.51"
      @database_name = "mod_cart_beta"

    when :preview
      @ip_address = "192.168.38.51"
      @database_name = "mod_cart_beta"

    when :demo
      @ip_address = "192.168.38.35"
      @database_name = "mod_cart_staging"
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
   sql = 'select count(*) from social_profiles'
  return sql
end

