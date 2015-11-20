class ShopsController <  ApplicationController

  include Base64ToUpload

  skip_before_action :verify_authenticity_token

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action(:only =>  [:create, :update]) { 
    base64_to_uploadedfile :shop, :logo
  }

  def update
     respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end   
  end

  private

  def set_post
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :desc, :logo, :banner)
  end

end