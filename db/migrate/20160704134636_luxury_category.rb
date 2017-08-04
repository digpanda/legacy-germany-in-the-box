class LuxuryCategory < Mongoid::Migration
  def self.up

    Category.create!(
      :name_translations => {en: 'Luxury', 'zh-CN': '奢侈品', de: 'Luxus'},
      :slug => 'luxury'
    )

  end

  def self.down
  end
end