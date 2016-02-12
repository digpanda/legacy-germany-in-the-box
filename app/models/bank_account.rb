class BankAccount
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :name,  type: String
  field :iban,  type: String
  field :bic,   type: String
  field :debit, type: Boolean, default: false

  belongs_to :shop

  validates :name,    presence: true
  validates :iban,    presence: true
  validates :bic,     presence: true
  validates :debit,   presence: true
end