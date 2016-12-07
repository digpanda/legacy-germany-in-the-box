module Wirecard
  class Base

    BASE_CONFIG = Rails.application.config.wirecard
    Error = Class.new(StandardError)

  end
end
