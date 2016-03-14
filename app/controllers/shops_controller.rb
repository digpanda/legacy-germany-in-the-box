class ShopsController <  ApplicationController

  include Base64ToUpload

  skip_before_action :verify_authenticity_token

  load_and_authorize_resource

  def update
     respond_to do |format|
       sp = shop_params

       current_user.shop.target_groups.clear unless sp[:target_groups]
       current_user.shop.sales_channels.clear unless sp[:sales_channels]

       if current_user.shop.update(sp)
        flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
        format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_shop) }
      else
        flash[:error] = current_user.shop.errors.full_messages.first
        format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_shop) }
      end
    end   
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :desc, :logo, :banner, :philosophy, :stories, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, target_groups:[], sales_channels:[] )
  end

end