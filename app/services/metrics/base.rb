class Metrics < BaseService
  class Base < Metrics
    attr_reader :metadata

    def initialize(metadata)
      @metadata = metadata
    end
  end
end
