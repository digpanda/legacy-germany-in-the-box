class ReferrerProvision
  include MongoidBase

  strip_attributes

  field :provision, type: Float

  belongs_to :referrer, class_name: 'Referrer', inverse_of: :provisions
  belongs_to :order
  belongs_to :inquiry

  def type
    if order
      :order
    elsif inquiry
      :inquiry
    end
  end

  def desc
    order&.products_name_array&.join(', ') || inquiry&.service&.name
  end

end
