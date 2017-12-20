class CacheSolver
  attr_reader :resources

  def initialize(resources)
    @resources = resources
  end

  end

  def solve(&block)
    return read_cache if read_cache
    
    data = capture do
      yield
    end

    write_cache
    read_cache
  end

  private

  def read_cache
    Rails.cache.fetch(cache_key)
  end

  def write_cache
    Rails.cache.write(cache_key, data)
  end

  def cache_key
    @cache_key ||= begin
      resources.map do |resource|
        if resource.respond_to?(:id)
          resource.id.to_s
        elsif resource.nil?
          'nil'
        else
          resource.to_s
        end
      end.join('-')
    end
  end

end
