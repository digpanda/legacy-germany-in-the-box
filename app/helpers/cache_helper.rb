module CacheHelper

  def solve_cache(&block)
    Rails.cache.fetch("anything", expires_in: 20.seconds) do
      content = yield
      puts "CONTENT #{content}"
    end
  end

end
