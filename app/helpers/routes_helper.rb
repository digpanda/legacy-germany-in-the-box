module RoutesHelper

  def admin_path?
    PathMatcher.new(request).include?(['/admin'])
  end

  def shopkeeper_path?
    PathMatcher.new(request).include?(['/shopkeeper'])
  end

  def customer_path?
    PathMatcher.new(request).include?(['/customer'])
  end

  def guest_path?
    PathMatcher.new(request).include?(['/guest'])
  end

end
