class ChangeDescriptionsCategories < Mongoid::Migration
  def self.up

    category = Category.where(slug: 'household').first
    if category
      category.desc_translations = {:en => '', :de => '', :'zh-CN' => '有机食品不是潮流，是每个关心身体健康的消费者的权益。来因盒用心挑选安全的有机食品，让你吃得安心无负担。'}
      category.save
    end

    category = Category.where(slug: 'medicine').first
    if category
      category.desc_translations = {:en => '', :de => '', :'zh-CN' => '后工业时代的德国有着两倍于中国的人口密度和森林覆盖率，喜爱饮酒吃肉的德国人也热爱运动，体格强健的民族拥有“战车”的美誉，健康的躯体是德国人在竞争中的脊梁和动力。他们对健康保健品的要求是什么呢？－答案是科学与自然的结合。'}
      category.save
    end

  end

  def self.down
  end
end