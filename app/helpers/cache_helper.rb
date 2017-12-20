module CacheHelper

  def solve_cache(resources, &block)
    CacheSolver.new(resources).solve do
      yield
    end
  end

end
