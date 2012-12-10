require 'yajl'
require 'json'

def get_file(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end

RegularUserData = get_file('regular_user.json')
FacebookUserData =  get_file('facebook_user.json')

def parse_json_data(path)
  json = File.new(path, 'r')
  hash = Yajl::Parser.new
  hash.parse(json)
end

def get_regular_user_data
  @regular_user_data ||= parse_json_data(RegularUserData)
end

def get_facebook_user_data
  @facebook_user_data ||= parse_json_data(FacebookUserData)
end

def write_json_data(path,tempHash)
  File.open(path, 'w')do |f|
    #f.write(JSON.pretty_generate(tempHash))
    f.write(tempHash.to_json)
  end
end



