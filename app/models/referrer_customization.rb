class ReferrerCustomization
  include MongoidBase

  strip_attributes

  field :active, type: Boolean, default: false

  field :title, type: String

  field :logo, type: String
  mount_uploader :logo, LogoUploader


  belongs_to :referrer, class_name: 'Referrer', inverse_of: :customization

  def active?
    self.active
  end

end
