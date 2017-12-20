module CacheHelper

  def solve_cache(resources, &block)
    CacheSolver.new(resources).solve(block)
  end

end
