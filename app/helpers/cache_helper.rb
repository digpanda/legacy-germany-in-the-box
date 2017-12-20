module CacheHelper

  def solve_cache(&block)
    return Rails.cache.fetch("anything") if Rails.cache.fetch("anything")
    data = capture do
      yield
    end
    Rails.cache.write("anything", data)
    Rails.cache.fetch("anything")
  end

end
