require "abstract_method"

module CategoryBase
  extend ActiveSupport::Concern

  include Mongoid::MagicCounterCache

  included do

    strip_attributes

    field :name,    type: String,   localize: true
    field :status,  type: Boolean,  :default => true

    # TODO : this should be removed
    field :children_count, type: Fixnum, default: 0

    has_many :children, :class_name => self.name, :inverse_of => :parent,  :dependent => :restrict

    belongs_to :parent, :class_name => self.name, :inverse_of => :children

    # SHOULD BE ANALYZED AND CERTAINLY CHANGED
    counter_cache :parent, :field => "children_count"

    validates :name,    presence: true, length: {maximum: Rails.configuration.gitb[:max_short_text_length]}
    validates :status,  presence: true

    scope :roots,           ->  { where(parent: nil) }
    scope :is_active,       ->  { where(:status => true) }
    scope :has_children,    ->  { where(:children_count.gt => 0) }

  end
end
