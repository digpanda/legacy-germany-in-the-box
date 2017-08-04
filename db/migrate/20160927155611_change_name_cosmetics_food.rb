class ChangeNameCosmeticsFood < Mongoid::Migration
  def self.up

    Category.where(slug: 'food').first.update!(:name_translations => {en: 'Food', 'zh-CN': '食品佳酿', de: 'Lebensmittel  & Getränke'})

    Category.where(slug: 'cosmetics').first.update!(:name_translations => {en: 'Cosmetics', 'zh-CN': '美妆护肤', de: 'Kosmetik & Pflege'})

  end

  def self.down
  end
end
