class Referrer
  include MongoidBase

  field :reference_id, type: String # was referrer_id in User
  field :nickname, type: String
  field :group, type: String

  belongs_to :user, :class_name => "User", :inverse_of => :referrer
  belongs_to :referrer_token, :class_name => "ReferrerToken", :inverse_of => :referrer

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

  def set_group(group)
    self.group = group unless self.group
    self.save
  end

  def short_nickname
    nickname&.split(//)&.first(3)&.join.to_s
  end

  def total_provisions
    provisions.sum(:provision) - provision_operations.sum(:amount)
  end

end
