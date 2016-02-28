class VariantOption
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,          type: String
  field :name_locales,  type: Hash

  embeds_many :suboptions, class_name: 'VariantOption', inverse_of: :parent

  embedded_in :parent,    inverse_of: :suboptions,   class_name: 'VariantOption'
  embedded_in :product,   inverse_of: :options

  validates :name,      presence: true

  before_destroy :check_dependent_skus

  private

    def check_dependent_skus
      p = self.parent ? self.parent.product : self.product

      if p.skus.detect { |s| s.option_ids.include?(self.id.to_s) }
        logger.info('------------------------------------------------------')
        return false
      end

      logger.info('+++++++++++++++++++++++++++++++++++++++++++++++++++++')
      return true
    end
end
