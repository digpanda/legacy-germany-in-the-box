class Metrics < BaseService
  CACHE_EXPIRATION = 1.hours.freeze

  attr_reader :metric

  def initialize(metric)
    @metric = metric
  end

  def render
    #Rails.cache.fetch("cache-metric-#{metric}" :expires_in => CACHE_EXPIRATION) do
      to_call.new.render if defined?(to_call)
    #end
  end

  def to_call
    "Metrics::#{metric.camelize}".constantize
  end
end
