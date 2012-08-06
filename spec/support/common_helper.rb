require "spec_helper"

def go_to_BTB_page
  visit '/'
end

def go_to_SDP_page
  visit 'http://btb.demo.modcloth.com/samples/56608-sample-2048'
end

def wait_for_script
  wait_until do
    page.evaluate_script('$.active') == 0
    end
end