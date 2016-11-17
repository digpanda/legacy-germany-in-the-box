module UserAsResource
  extend ActiveSupport::Concern

  binding.pry
  #
  # included do
  #   helper_method :resource_name, :resource, :devise_mapping
  # end
  #
  # # def resource_name
  # #   binding.pry
  # #   :user
  # # end
  # #
  # # def resource
  # #   @resource ||= User.new
  # # end
  # #
  # # def devise_mapping
  # #   @devise_mapping ||= Devise.mappings[:user]
  # # end

end
