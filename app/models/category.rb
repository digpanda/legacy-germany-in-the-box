class Category
  include MongoidBase

  strip_attributes

  field :name,    type: String
  field :code,    type: String
  field :cssc,    type: String
  field :status,  type: Boolean,  :default => true

  has_many :children, :class_name => 'Category', :inverse_of => :parent,  dependent: :restrict
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children

  has_and_belongs_to_many :products,  :inverse_of => :categories

  validates :name,    presence: true, length: {maximum: Rails.configuration.max_short_text_length}
  validates :code,    presence: true, :unless => lambda { self.parent.blank? }, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :status,  presence: true

  scope :roots,           ->  { where(:parent => nil) }
  scope :is_active,       ->  { where( :status => true ) }

  def total_products
    if children.count > 0
      children.is_active.inject(0) { |sum, c| sum += c.total_products }
    else
      products.count
    end
  end

  def next_2_last_branche?
    if children.count > 0
      return nil == children.detect { |c| c.children.count > 0 }
    end

    return false
  end
end