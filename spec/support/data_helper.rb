require 'yajl'

def get_file(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end

UserData = get_file('users.json')

def parse_json_data(path)
  json = File.new(path, 'r')
  hash = Yajl::Parser.new
  hash.parse(json)
end

def get_user_data
  @data ||= parse_json_data(UserData)
end


