class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :token, :full_name, :nickname, :total_bought, :resellers_platform_at

  def full_name
    object.decorate.full_name
  end

  def total_bought
    object.total_bought.in_euro.display
  end

end
