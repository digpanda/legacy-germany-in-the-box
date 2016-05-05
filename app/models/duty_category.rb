class DutyCategory
  include MongoidBase
  include CategoryBase

  field :code,            type: String
  field :products_count,  type: Fixnum, default: 0

  has_many :products,  :inverse_of => :duty_category

  validates :code,  presence: true, :unless => lambda { self.parent.blank? }, length: {maximum: Rails.configuration.max_tiny_text_length}

  def total_products
    if children_count > 0
      children.is_active.inject(0) { |sum, c| sum += c.total_products }
    else
      products_count
    end
  end

  def second_last_branche?
    return false if products_count > 0

    if children_count > 0
      return nil == children.detect { |c| c.children_count > 0 }
    end

    return false
  end
end