module Wirecard
  class Base

    include Rails.application.routes.url_helpers # manipulate paths

    BASE_CONFIG = Rails.application.config.wirecard
    
    Error = Class.new(StandardError)

  end
end