# simple library to check if the paths match or don't match
# this is used mainly for the view within helpers
# TODO : we could improve it to abstract the NavigationHistory::Store class
# which contains a very similar logic.
class PathMatcher

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def include?(paths)
    paths.each do |path|
      return true if match_location?(path)
    end
    false
  end

  def exclude?(paths)
    paths.each do |path|
      return false if match_location?(path)
    end
    true
  end

  def match_location?(path)
    location_path.index(path) == 0
  end

  def location_path
    request.fullpath
  end

end
