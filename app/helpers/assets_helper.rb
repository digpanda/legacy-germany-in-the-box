require 'digest/md5'

# each asset will be refreshed from the user cache depending
# on the time of last compilation
# NOTE : one file can be re-compiled and not the others
# this optimization make it faster to display the page after an update
# of a specific section, chunk of the code.
module AssetsHelper
  CSS_APP_PATH = 'public/stylesheets/'
  JS_APP_PATH = 'public/javascripts/'

  def solve_section
    identity_solver.section
  end

  def assets_css_version_hash(filename)
    Digest::MD5.hexdigest("#{css_version(filename)}")
  end

  def assets_js_version_hash(filename)
    Digest::MD5.hexdigest("#{js_version(filename)}")
  end

  def assets_version(path)
    File.mtime(Rails.root.join(path))
  end

  def css_version(filename)
    assets_version("#{CSS_APP_PATH}/#{filename}.css")
  end

  def js_version(filename)
    assets_version("#{JS_APP_PATH}/#{filename}.js")
  end
end
