require 'postgres'
require 'capybara_support/configuration'

def connection(options)
  query_name = options[:query_name] || :SDP
  @database_name = options[:database_name] || :comments
  @commentable_name = options[:commentable_name]
  @product_id = options[:product_id]


  get_environment()
  @port_number = 5432
  puts "Database name is: #{@database_name}"
  puts "Query name is: #{query_name}"
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

#private
#def get_environment1()
#  env = $environment #Global variable from configuration file
#  case env
#    when :stage
#      @ip_address = ""
#      @database_name = ""
#      @user_name = ""
#      @password = ""
#
#    when :production
#      @ip_address = ""
#      @database_name = ""
#      @user_name = ""
#      @password = ""
#
#    when :preview
#      @ip_address = ""
#      @database_name = ""
#      @user_name = ""
#      @password = ""
#
#    when :demo
#      @ip_address = "192.168.113.22"
#      @database_name = "comments"
#      @user_name = "comments"
#      @password = "alfjljqreovcab408qewfasdlj"
#  end
#  @url = CapybaraSupport::Configuration.get_environment_url
#end

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
      @ip_address = "192.168.113.22"
      @database_name = "comments"
      @user_name = "comments"
      @password = "alfjljqreovcab408qewfasdlj"
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
      @user_name = ""
      @password = ""

    when :demo
      @ip_address = "btb.demo.modcloth.com"
      @database_name = "btb"
      @user_name = "btb"
      @password = "mcuemcvhbuoaec"
  end
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

    when :Voting_in_progress_SampleDetails
      sql = "SELECT s.name, s.price, s.voting_starts_at,date_trunc('hour',s.voting_ends_at - now()) as voting_time, count(v.product_id)
             FROM samples s FULL OUTER JOIN votes v ON s.product_id = v.product_id
             WHERE s.product_id =" +@product_id+
             "GROUP BY v.product_id, s.name, s.voting_starts_at, s.price, s.voting_starts_at,s.voting_ends_at
             ORDER BY s.voting_starts_at DESC
             LIMIT 1"

    when :Voting_in_progress_SampleCount
      sql = "SELECT count(*)
             FROM samples
             WHERE state ='active' AND (voting_starts_at <= now() AND voting_ends_at > now())"

    when :Voting_in_progress_CommentCount
      #commentable_name = "Sample 2031".gsub("Sample ",'')  #Need to include this line in voting in progress scripts
      commentable_name = @commentable_name.gsub("Sample ",'')  #Need to include this line in voting in progress scripts
      puts "Commentable name is:#{commentable_name}"
      sql = "SELECT count(*) FROM comments where commentable_name = " + "'" + commentable_name + "'" + ""

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
      @url = @url + '/samples/' + commentable_id+'-sample-'+ commentable_name
      return @url

    when :DeleteComments
      puts "Comments deleted successfully for user #{$email}"

    when :Voting_in_progress_SampleDetails
      $sample_name = res.getvalue(0, 0)
      $sample_price = res.getvalue(0, 1)
      $voting_time =  res.getvalue(0, 3)
      $vote_count = res.getvalue(0, 4)
      puts "Sample name is ****************- #{$sample_name}"
      puts "Sample price is ****************- #{$sample_price}"
      puts "Vote count is ****************- #{$vote_count}"
      puts "voting time is ****************- #{$voting_time}"

    else
      value = res.getvalue(0, 0)
      return value
  end
end

