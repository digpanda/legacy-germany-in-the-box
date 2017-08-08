module MongoidBase
  extend ActiveSupport::Concern

  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short
end
