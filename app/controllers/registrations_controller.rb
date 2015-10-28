class RegistrationsController < Devise::RegistrationsController
  protected



  def after_sign_in_path_for(resource)
    '/productsi/50'
  end


  def after_inactive_sign_up_path_for(resource)
    '/user/openmailnoti'
  end
end