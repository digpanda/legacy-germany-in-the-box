class BannerBaseSetup < Mongoid::Migration
  def self.up
    Banner.create(location: :shops_landing_cover)
    Banner.create(location: :package_sets_landing_cover)
  end

  def self.down
  end
end
