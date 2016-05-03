module CategoryBase
  extend ActiveSupport::Concern
  extend Mongoid::Includes

  included do
    strip_attributes

    field :name,    type: String,   localize: true
    field :status,  type: Boolean,  :default => true

    has_many :children, :class_name => self.name, :inverse_of => :parent,  :dependent => :restrict
    belongs_to :parent, :class_name => self.name, :inverse_of => :children

    has_and_belongs_to_many :products,  :inverse_of => :categories

    validates :name,    presence: true, length: {maximum: Rails.configuration.max_short_text_length}
    validates :status,  presence: true

    scope :roots,           ->  { where(:parent => nil) }
    scope :is_active,       ->  { where(:status => true) }

    # Category.roots.tree -> currently not used in the system
    # We should integrate it to the caterories menu (categories.html.haml)
    def self.tree
      is_active.includes(:children, from: :parent).map(&:restricted)
    end

    def restricted
      [self.id, self.name, children_tree]
    end

    def children_tree
      children.tree
    end
    # end tree

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

end