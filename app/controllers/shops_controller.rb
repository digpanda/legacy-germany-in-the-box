class ShopsController <  ApplicationController

  include Base64ToUpload

  skip_before_action :verify_authenticity_token

  before_action(:only =>  [:create, :update]) { 
    base64_to_uploadedfile :shop, :logo
  }

end