class Referrer
  include MongoidBase
  include Mongoid::Search

  # research system
  search_in :id, :reference_id, :nickname, :group, :coupons => :code, :user => :email

  field :reference_id, type: String # was referrer_id in User
  field :nickname, type: String
  field :group, type: String # not sure it's still in use in our system since we use referrer group
  field :agb, type: Boolean, default: false

  belongs_to :user, :class_name => "User", :inverse_of => :referrer
  belongs_to :referrer_group, :class_name => "ReferrerGroup", :inverse_of => :referrer

  has_many :coupons, :class_name => "Coupon", :inverse_of => :referrer

  has_many :provisions, :class_name => "ReferrerProvision", :inverse_of => :referrer
  has_many :provision_operations, :class_name => "ReferrerProvisionOperation", :inverse_of => :referrer

  before_create :ensure_reference_id, :ensure_nickname

  def has_coupon?
    self.coupons.count > 0
  end

  def ensure_reference_id
    unless self.reference_id
      self.reference_id = "#{self.short_nickname}#{self.user.short_union_id}#{Time.now.day}#{Time.now.month}#{Time.now.year}".downcase
    end
  end

  def ensure_nickname
    self.nickname = self.user.nickname unless self.nickname
  end

  def short_nickname
    nickname&.split(//)&.first(3)&.join.to_s
  end

  def current_balance
    total_earned + provision_operations.sum(:amount)
  end

  def total_earned
    provisions.sum(:provision)
  end

end
