require 'postgres'
require 'capybara_support/configuration'

def connection(options)
  query_name = options[:query_name] || :SDP
  @database_name = options[:database_name] || :comments
  @commentable_name = options[:commentable_name]
  @product_id = options[:product_id]

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
  if (@database_name == :comments)
    comments_database(env)
  else
    BTB_database(env)
  end
  @url = CapybaraSupport::Configuration.get_environment_url
end

private
def comments_database(env)
  case env
    when :stage
      @ip_address = ""
      @user_name = ""
      @password = ""

    when :production
      @ip_address = ""
      @user_name = ""
      @password = ""

    when :preview
      @ip_address = ""
      @user_name = ""
      @password = ""

    when :demo
      @ip_address = "192.168.113.17"
      @database_name = "comments_demo"
      @user_name = "rkalbhor"
      @password = "HbusEU66jTLszq"
  end
end

private
def BTB_database(env)
  case env
    when :stage
      @ip_address = ""
      @user_name = ""
      @password = ""

    when :production
      @ip_address = ""
      @user_name = ""
      @password = ""

    when :preview
      @ip_address = ""
      @database_name = ""
      @user_name = ""
      @password = ""

    when :demo
      @ip_address = "192.168.113.14"
      @database_name = "btb_demo"
      @user_name = "rkalbhor"
      @password = "HbusEU66jTLszq"
  end
end

private
def query_collection(query_name)
  case query_name

    when :SampleDetails
      sql = "SELECT s.name, s.price, s.voting_starts_at,to_char(s.voting_ends_at,'mm/dd/yy'),date_trunc('hour',s.voting_ends_at - now()) as voting_time, count(v.product_id)
             FROM samples s FULL OUTER JOIN votes v ON s.product_id = v.product_id
             WHERE s.product_id =" +@product_id+
             "GROUP BY v.product_id, s.name, s.voting_starts_at, s.price, s.voting_starts_at,s.voting_ends_at
             ORDER BY s.voting_starts_at DESC
             LIMIT 1"

    when :Voting_in_progress_SampleCount
      sql = "SELECT count(*)
             FROM samples
             WHERE state ='active' AND (voting_starts_at <= now() AND voting_ends_at > now())"

    when :Awaiting_results_SampleCount
      sql = "SELECT count(*)
             FROM samples
             WHERE (state = 'pending' or state = 'active' or state = 'picked' or state = 'skipped' or state = 'not_picked') AND voting_ends_at <= now() and (announced_at is null OR announced_at > now())"

    when :In_Production_SampleCount
      sql = "SELECT count(*)
             FROM samples
             WHERE (state = 'picked' AND announced_at <= now() AND (initially_launched_at is null or initially_launched_at > now()))"

    when :CommentCount
      sql = "SELECT count(*) FROM comments where commentable_name = " + "'" + @commentable_name + "'" + " and status = 'active'"

    when :Skipped_Sample
      sql = "SELECT product_id FROM samples
             WHERE state = 'skipped' or state = 'not_picked'
             limit 1"
    else
      print "\n No matching query..Please check your typos.... \n"
      sql = nil
  end
  return sql
end

private
def query_result(query_name, res)
  case query_name
    when :SampleDetails
      $sample_name = res.getvalue(0, 0)
      $sample_price = res.getvalue(0, 1)
      $voting_ends_at = res.getvalue(0, 3)
      $voting_time = res.getvalue(0, 4)
      $vote_count = res.getvalue(0, 5)

    #puts "Sample name is ****************- #{$sample_name}"
    #puts "Sample price is ****************- #{$sample_price}"
    #puts "Vote count is ****************- #{$vote_count}"
    #puts "voting time is ****************- #{$voting_time}"
    #puts "voting ends at is ****************- #{$voting_ends_at}"
    else
      value = res.getvalue(0, 0)
      return value
  end
end