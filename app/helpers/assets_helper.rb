require 'digest/md5'

module AssetsHelper

  CSS_APP_PATH = "public/stylesheets/shared.css"

  def solve_section
    if potential_customer?
      :customer
    elsif potential_shopkeeper?
      :shopkeeper
    elsif potential_admin?
      :admin
    end
  end

  def assets_version_hash
    Digest::MD5.hexdigest(assets_version.to_s)
  end

  def assets_version
    File.mtime(Rails.root.join(CSS_APP_PATH)) # we don't need to check anything else because we use brunch and everything is recompiled systematically
  end

end
