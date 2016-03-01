class ShopsController <  ApplicationController

  include Base64ToUpload

  skip_before_action :verify_authenticity_token

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  before_action(:only =>  [:create, :update]) { 
    base64_to_uploadedfile :shop, :logo
  }

  def update
     respond_to do |format|
      if @shop.update(shop_params)
        flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
        format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_shop) }
      else
        flash[:error] = @shop.errors.full_messages.first
        format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_shop) }
      end
    end   
  end

  private

  def set_post
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :desc, :logo, :banner, :philosophy, :story, :ustid, :eroi, :sms, :sms_mobile, :min_total, :currency, :status)
  end

end