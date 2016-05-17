require "abstract_method"

module CategoryBase
  extend ActiveSupport::Concern

  include Mongoid::MagicCounterCache

  included do

    strip_attributes

    field :name,    type: String,   localize: true
    field :status,  type: Boolean,  :default => true

    has_many :children, :class_name => self.name, :inverse_of => :parent,  :dependent => :restrict

    belongs_to :parent, :class_name => self.name, :inverse_of => :children

    field :children_count, type: Fixnum, default: 0
    counter_cache :parent, :field => "children_count"

    validates :name,    presence: true, length: {maximum: Rails.configuration.max_short_text_length}
    validates :status,  presence: true

    scope :roots,           ->  { where(:parent => nil) }
    scope :is_active,       ->  { where(:status => true) }
    scope :has_children,    ->  { where(:children_count.gt => 0) }

    index({parent: 1},      {unique: false, name: :idx_category_parent, sparse: true})

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

    abstract_method :total_products, :second_last_branche?
  end
end