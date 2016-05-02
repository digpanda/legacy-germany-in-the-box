module Wirecard
  class Reseller

    attr_reader :username, 
                :password, 

    def initialize(args={})

      @username ||= ::Rails.application.config.wirecard["reseller"]["username"]
      @password ||= ::Rails.application.config.wirecard["reseller"]["password"]

    end

  end
end