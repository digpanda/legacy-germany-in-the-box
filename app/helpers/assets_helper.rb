require 'digest/md5'

module AssetsHelper

  def assets_version_hash
    Digest::MD5.hexdigest(assets_version)
  end

  def assets_version
    File.mtime(Rails.root.join("public/assets/stylesheets/app.css")) # we don't need to check anything else because we use brunch and everything is recompiled systematically
  end

end