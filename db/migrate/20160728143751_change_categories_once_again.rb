class ChangeCategoriesOnceAgain < Mongoid::Migration
  def self.up

    category = Category.where(slug: 'medicine').first
    if category
      category.desc_translations = {:en => '', :de => '', :'zh-CN' => '后工业时代的德国有着两倍于中国的人口密度和森林覆盖率🌲，喜爱饮酒🍺吃肉🍖的德国人也热爱运动🚴🏂🏇，这个体格强健的民族拥有“战车”的美誉，健康的躯体是德意志民族在竞争中的脊梁和动力。他们对健康保健品的要求是什么呢？－答案是科学与自然的结合'}
      category.save
    end

    category = Category.where(slug: 'fashion').first
    if category
      category.desc_translations = {:en => '', :de => '', :'zh-CN' => '德国和时尚？这是两个完全不相干的概念嘛😂－事实上从德国走出了很多世界顶级的设计师，如Karl Lagerfeld、Jil Sander等等。穿一件特立独行的德国独立设计师的衣服去下一个派对，让你的闺蜜们去猜这是谁的作品，也许Ta就是下一个Lagerfeld呢？'}
      category.save
    end

    category = Category.where(slug: 'household').first
    if category
      category.desc_translations = {:en => '', :de => '', :'zh-CN' => '简约的风格，和材料永不妥协的死磕，古典🎼般的制作工艺，完美主义的匠人精神📐，这些基因一一融入来因盒挑选的德国家居用品🏡。满足你身在东方古国，却对欧陆风情的偏爱，对品质生活的追求。但最好的是，这一切会随着的🕙流逝而愈发彰显它们的价值、、、'}
      category.save
    end

  end

  def self.down
  end
end