require 'test_helper'
require 'border_guru/requests/base'

class BorderGuru::BaseTest < ActiveSupport::TestCase

  test 'reading the config from a file' do
    assert_instance_of Hash, BorderGuru::Requests::Base::CONFIG
  end

end
