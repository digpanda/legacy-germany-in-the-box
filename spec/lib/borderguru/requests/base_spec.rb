require 'rails_helper'
require 'border_guru/requests/base'

describe BorderGuru::Requests::Base::CONFIG do

  it 'is a hash' do
    assert_instance_of Hash, BorderGuru::Requests::Base::CONFIG
  end

end