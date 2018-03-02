class ReferrerSerializer < ActiveModel::Serializer
  attributes :id, :agb, :c_at, :group, :group_leader, :label, :nickname, :reference_id, :total_growth, :total_resells

  belongs_to :user
  has_one :referrer_group

  def total_growth
    object.total_growth.in_euro.display
  end

  def total_resells
    object.total_resells.in_euro.display
  end

end
