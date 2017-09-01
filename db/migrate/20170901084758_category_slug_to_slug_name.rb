class CategorySlugToSlugName < Mongoid::Migration
  def self.up
    Category.all.each do |category|
      old_slug = category.attributes["slug"]
      category.update!(slug_name: old_slug)
      puts "Category #{category.id} `slug_name` updated to `#{category.slug_name}`"
    end
  end

  def self.down
  end
end
