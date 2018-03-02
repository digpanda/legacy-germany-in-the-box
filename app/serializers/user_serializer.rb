class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :token, :full_name, :nickname

  def full_name
    object.decorate.full_name
  end

end
