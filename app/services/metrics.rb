class Metrics < BaseService
  CACHE_EXPIRATION = 1.hours.freeze

  attr_reader :metric

  def initialize(metric)
    @metric = metric
  end

  def render
    #Rails.cache.fetch("cache-metric-#{metric}", :expires_in => CACHE_EXPIRATION) do
      to_call.new.render if defined?(to_call)
    #end
  end

  protected

    # NOTE : this allows us to draw different lines datasets within a graph
    # right from the #render from any method in a subclass.
    # e.g. draw(:new_users_per_month, label: 'New users', color: :light)
    def draw(metric, *args)
      draw = chart.draw(*args)
      self.send(metric).each do |metric|
        draw.data(position: metric.first, value: metric.last)
      end
      draw.store
    end

    # NOTE : settings is set in each subclass in the initializer
    def chart
      @chart ||= Chart.new(settings)
    end

  private

    def to_call
      "Metrics::#{metric.to_s.camelize}".constantize
    end
end
