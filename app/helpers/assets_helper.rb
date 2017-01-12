require 'digest/md5'

module AssetsHelper

  CSS_APP_PATH = "public/stylesheets/"
  JS_APP_PATH = "public/javascripts/"

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
