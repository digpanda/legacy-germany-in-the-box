class Address
  include MongoidBase

  strip_attributes

  field :additional,    type: String
  field :number,        type: String
  field :street,        type: String
  field :district,      type: String
  field :city,          type: String
  field :province,      type: String
  field :zip,           type: String
  field :country,       type: ISO3166::Country
  field :type,          type: String # billing, sender, both
  field :company,       type: String

  field :fname,         type: String
  field :lname,         type: String
  field :pid,           type: String
  field :email,         type: String
  field :mobile,        type: String
  field :primary,       type: Boolean,    default: false

  belongs_to :user,     :inverse_of => :addresses;
  belongs_to :shop,     :inverse_of => :address;

  scope :is_billing,        ->  { any_of({type: 'billing'}, {type: 'both'}) }
  scope :is_sender,         ->  { any_of({type: 'sender'},  {type: 'both'}) }
  scope :is_any,            ->  { any_of({type: 'sender'},  {type: 'billing'}, {type: 'both'}) }

  scope :is_only_billing,   ->  { any_of({type: 'billing'}) }
  scope :is_only_sender,    ->  { any_of({type: 'sender'}) }
  scope :is_only_both,      ->  { any_of({type: 'both'}) }

  validates :pid,       presence: true,   length: {minimum:18}, :if => lambda{ user&.role == :customer }
  validates :fname,     presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :lname,     presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :mobile,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ user != nil }
  validates :number,    presence: false,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :street,    presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :city,      presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :zip,       presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :country,   presence: true
  validates :primary,   presence: true

  validates :district,  length: {maximum: Rails.configuration.max_tiny_text_length}, :if => lambda{ user == nil && shop != nil }

  validates :district,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ user != nil && shop == nil }
  validates :company,   presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ shop != nil }
  validates :province,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}

  validates :type,      presence: true,   inclusion: {in: ['billing', 'sender', 'both']},    :if => lambda{ shop != nil && user == nil }

  index({shop: 1},      {unique: false, name: :idx_address_shop, sparse: true})
  index({type: 1},      {unique: false, name: :idx_address_type, sparse: true})
  index({user: 1},      {unique: false, name: :idx_address_user, sparse: true})

end
