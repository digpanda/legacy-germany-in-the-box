class BankAccount
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :name,  type: String
  field :iban,  type: String
  field :bic,   type: String
  field :debit, type: Boolean, default: false

  belongs_to :shop

  validates :name,    presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :iban,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :bic,     presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :debit,   presence: true
  validates :shop,    presence: true
end