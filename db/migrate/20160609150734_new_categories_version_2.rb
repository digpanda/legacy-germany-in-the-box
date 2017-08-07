class NewCategoriesVersion2 < Mongoid::Migration
  def self.up

    Category.all.delete

    #
    # root category - level 0
    #
    category_food_drinks = Category.create!(
        name_translations: {en: 'Food', 'zh-CN': '食品', de: 'Lebensmittel  & Getränke'},
        :slug => 'food',
        :desc_translations => {en: '', de: '', 'zh-CN': '有机食品不是潮流，是每个关心身体健康的消费者的权益。来因盒用心挑选安全的有机食品，让你吃得安心无负担。'}
    )

    category_medicine_care = Category.create!(
        name_translations: {en: 'Medicine', 'zh-CN': '药品保健', de: 'Gesundheit & Medizin'},
        :slug => 'medicine',
        :desc_translations => {en: '', de: '', 'zh-CN': '来因盒里的营养保健品让全家老老少少健康有活力，不用担心夏季蚊虫叮咬，户外活动不小心的伤口处理也有靠谱的德国伤口消毒和除疤药膏。'}
    )

    category_cosmetics_care = Category.create!(
        name_translations: {en: 'Cosmetics', 'zh-CN': '美妆', de: 'Kosmetik & Pflege'},
        :slug => 'cosmetics',
        :desc_translations => {en: '', de: '', 'zh-CN': '德国有机护肤品给妳全身肌肤的照顾，来因盒里众多品牌兼顾男女护肤需求、夏季防晒和除毛后保养任君挑选。'}

    )

    category_fashion = Category.create!(
        name_translations: {en: 'Fashion', 'zh-CN': '时尚', de: 'Mode'},
        :slug => 'fashion',
        :desc_translations => {en: '', de: '', 'zh-CN': '想找些特别不跟别人撞衫的时装和配件？想为自己的孩子选件不会过敏的洋装？到来因盒里找找，包君满意。'}
    )

    Rails.cache.clear

  end

  def self.down
  end
end