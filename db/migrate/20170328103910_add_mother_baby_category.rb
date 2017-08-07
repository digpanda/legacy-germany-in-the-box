class AddMotherBabyCategory < Mongoid::Migration
  def self.up
    Category.create!(
        name_translations: {en: 'Mother Baby', 'zh-CN': '母婴', de: 'Mutter und Kind'},
        :slug => 'mother_baby',
        :desc_translations => {en: '', de: '', 'zh-CN': '德国素来以严谨的生产态度为世人所称道，对于品质有着严格的要求，尤其是德国的母婴用品，提供最佳的高质量，纯天然呵护。'}
    )
  end

  def self.down
  end
end