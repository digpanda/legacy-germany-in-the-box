class PackageSet
  include MongoidBase

  field :name

  belongs_to :shop, inverse_of: :package_sets
  embeds_many :package_skus, inverse_of: :package_set, cascade_callbacks: true
  accepts_nested_attributes_for :package_skus, :reject_if => :reject_package_skus

  def reject_package_skus(attributed)
    attributed['product'].blank? && attributed['sku_id'].blank?
  end

  validates_presence_of :name

end
