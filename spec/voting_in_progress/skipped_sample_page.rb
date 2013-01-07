# encoding: utf-8
require "spec/spec_helper"

describe 'Skipped Sample page' do

  before(:all) do
    go_to_BTB_page
  end

    it '1. Go to Skipped sample page.' do
    product_id = get_product_id_for_skipped_sample
      visit '/' + '/samples/11852-sample'
      sleep(10)
    end
  end
