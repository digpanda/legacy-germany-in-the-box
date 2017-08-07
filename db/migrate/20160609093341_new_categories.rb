class NewCategories < Mongoid::Migration
  def self.up

    Category.all.delete

    #
    # root category - level 0
    #
    category_food_drinks = Category.create!(
        name_translations: {en: 'Food', 'zh-CN': '食品和饮料', de: 'Lebensmittel  & Getränke'},
        :slug => 'food'
    )

    category_medicine_care = Category.create!(
        name_translations: {en: 'Medicine', 'zh-CN': '药品保健', de: 'Gesundheit & Medizin'},
        :slug => 'medicine'
    )

    category_cosmetics_care = Category.create!(
        name_translations: {en: 'Cosmetics', 'zh-CN': '美妆', de: 'Kosmetik & Pflege'},
        :slug => 'cosmetics'
    )

    category_fashion = Category.create!(
        name_translations: {en: 'Fashion', 'zh-CN': '时尚', de: 'Mode'},
        :slug => 'fashion'
    )

    Rails.cache.clear

  end

  def self.down
  end
end