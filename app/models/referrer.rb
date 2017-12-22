class Referrer
  include MongoidBase
  include Mongoid::Search

  # research system
  search_in :id, :reference_id, :nickname, :group, coupons: :code, user: [:email, decorate: :full_name], group: :name

  field :reference_id, type: String # was referrer_id in User
  field :nickname, type: String
  field :group, type: String # not sure it's still in use in our system since we use referrer group
  field :agb, type: Boolean, default: false
  field :label, type: String

  belongs_to :user, class_name: 'User', inverse_of: :referrer
  has_many :children_users, class_name: 'User', inverse_of: :parent_referrer

  belongs_to :referrer_group, class_name: 'ReferrerGroup', inverse_of: :referrer

  has_many :coupons, class_name: 'Coupon', inverse_of: :referrer
  has_many :orders, class_name: 'Order', inverse_of: :referrer
  has_many :inquiries, class_name: 'Inquiry', inverse_of: :referrer

  has_many :provisions, class_name: 'ReferrerProvision', inverse_of: :referrer
  has_many :provision_operations, class_name: 'ReferrerProvisionOperation', inverse_of: :referrer

  before_create :ensure_reference_id, :ensure_nickname

  # we actually get the metadata from the notifications
  # and reduce the id
  def newly_published_links
    user.notifications.where(scope: :referrer_links).unreads.map(&:metadata).reduce([]) do |acc, metadata|
      acc << metadata['link_id']
    end
  end

  # we loop to confirm the link was read
  # the notification matching with this specific link on this scope
  # will be considered read.
  def link_was_read!(link)
    user.notifications.where(scope: :referrer_links).unreads.each do |notification|
      if notification.metadata['link_id'] == link.id
        notification.read!
      end
    end
  end

  def has_coupon?
    self.coupons.not_expired.count > 0
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

  def total_growth
    provisions.reduce(0) do |acc, provision|
      acc + provision.order.end_price
    end
  end

  def total_resells
    user.orders.bought.reduce(0.0) do |acc, order|
      if order.price_origins.include?(:reseller_price)
        acc + order.end_price
      end
    end || 0.0
  end

  def main_coupon
    coupons.not_expired.first
  end

end
