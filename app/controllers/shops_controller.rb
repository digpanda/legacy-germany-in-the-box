class ShopsController <  ApplicationController

  include Base64ToUpload

  skip_before_action :verify_authenticity_token

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action(:only =>  [:create, :update]) { 
    base64_to_uploadedfile :shop, :logo
  }

  private

  def set_post
    @shop = Shop.find(params[:id])
  end

  def post_params
    params.require(:shop).permit(:name, :desc, :logo, :banner)
  end

end