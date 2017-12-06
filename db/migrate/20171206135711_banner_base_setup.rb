class BannerBaseSetup < Mongoid::Migration
  def self.up
    Banner.create(location: :shops_landing)
    Banner.create(location: :package_sets_landing)
  end

  def self.down
  end
end
