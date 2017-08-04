class ChangeCategoriesLuxuryToHousehold < Mongoid::Migration
  def self.up

    category = Category.where(slug: 'luxury').first
    if category
      category.slug = 'household'
      category.name_translations = {en: 'Household', 'zh-CN': '家居', de: 'Haushalt'}
      category.save!
    end
  end

  def self.down
  end
end