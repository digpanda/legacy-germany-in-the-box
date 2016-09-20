class ChangeCategoriesPositions < Mongoid::Migration
  def self.up

    # cosmetics, medicine, fashion, food, household
    ['cosmetics', 'medicine', 'fashion', 'food', 'household'].each_with_index do |slug, index|
      category = Category.where(slug: slug).first
      category.position = index
      category.save
    end

  end

  def self.down
  end
end
