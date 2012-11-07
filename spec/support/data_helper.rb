require 'yajl'
require 'json'

def get_file(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end

UserData = get_file('users.json')
ProductData = get_file('products.json')

def parse_json_data(path)
  json = File.new(path, 'r')
  hash = Yajl::Parser.new
  hash.parse(json)
end

def get_user_data
  @data ||= parse_json_data(UserData)
end

def get_product_data
  @data ||= parse_json_data(ProductData)
end

def write_json_data(path,tempHash)
  File.open(path, 'w')do |f|
    f.write(JSON.pretty_generate(tempHash))
  end
end



