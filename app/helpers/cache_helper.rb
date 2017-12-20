module CacheHelper

  def solve_cache(request, resources, &block)

    cache_key = resources.map do |resource|
      if resource.respond_to?(:id)
        resource.id.to_s
      elsif resource.nil?
        'nil'
      else
        resource.to_s
      end
    end.join('-')

    return Rails.cache.fetch(cache_key) if Rails.cache.fetch(cache_key)
    data = capture do
      yield
    end
    Rails.cache.write(cache_key, data)
    Rails.cache.fetch(cache_key)
  end

end
