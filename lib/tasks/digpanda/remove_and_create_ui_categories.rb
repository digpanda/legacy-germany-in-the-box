class Tasks::Digpanda::RemoveAndCreateUiCategories
  def initialize

    devlog 'We first delete the UI categories'
    Category.delete_all

    #
    # root category - level 0
    #
    devlog 'Let\'s generate them again'
    Category.create!(
      name_translations: { en: 'Food', 'zh-CN': '食品佳酿', de: 'Lebensmittel  & Getränke' },
      slug: 'food',
      desc_translations: { en: '', de: '', 'zh-CN': '有机食品不是潮流，是每个关心身体健康的消费者的权益。来因盒用心挑选安全的有机食品，让你吃得安心无负担。' }
    )

    Category.create!(
      name_translations: { en: 'Medicine', 'zh-CN': '药品保健', de: 'Gesundheit & Medizin' },
      slug: 'medicine',
      desc_translations: { en: '', de: '', 'zh-CN': '来因盒里的营养保健品让全家老老少少健康有活力，不用担心夏季蚊虫叮咬，户外活动不小心的伤口处理也有靠谱的德国伤口消毒和除疤药膏。' }
    )

    Category.create!(
      name_translations: { en: 'Cosmetics', 'zh-CN': '美妆护肤', de: 'Kosmetik & Pflege' },
      slug: 'cosmetics',
      desc_translations: { en: '', de: '', 'zh-CN': '德国有机护肤品给妳全身肌肤的照顾，来因盒里众多品牌兼顾男女护肤需求、夏季防晒和除毛后保养任君挑选。' }

    )

    Category.create!(
      name_translations: { en: 'Fashion', 'zh-CN': '时尚', de: 'Mode' },
      slug: 'fashion',
      desc_translations: { en: '', de: '', 'zh-CN': '想找些特别不跟别人撞衫的时装和配件？想为自己的孩子选件不会过敏的洋装？到来因盒里找找，包君满意。' }
    )

    Category.create!(
      name_translations: { en: 'Household', 'zh-CN': '家居', de: 'Haushalt' },
      slug: 'household',
      desc_translations: { en: '', de: '', 'zh-CN': '简约的风格，和材料永不妥协的死磕，古典🎼般的制作工艺，完美主义的匠人精神📐，这些基因一一融入来因盒挑选的德国家居用品🏡。满足你身在东方古国，却对欧陆风情的偏爱，对品质生活的追求。但最好的是，这一切会随着的🕙流逝而愈发彰显它们的价值、、、' }
    )

    # cosmetics, medicine, fashion, food, household
    ['cosmetics', 'medicine', 'fashion', 'food', 'household'].each_with_index do |slug, index|
      category = Category.where(slug: slug).first
      category.position = index
      category.save
    end

    Rails.cache.clear

    devlog 'End of process.'

  end

  def devlog(message)
    unless Rails.env.test?
      puts message
    end
  end
end
