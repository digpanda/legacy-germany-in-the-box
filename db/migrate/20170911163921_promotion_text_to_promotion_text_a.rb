class PromotionTextToPromotionTextA < Mongoid::Migration
  def self.up
    Link.all.each do |link|
      link.promotion_text_a = link.attributes['promotion_text']
      link.save!(validate: false)
    end
  end

  def self.down
  end
end
