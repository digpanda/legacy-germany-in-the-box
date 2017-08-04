class Guest::HomeController < ApplicationController
  before_action :admin_redirection, :shopkeeper_redirection

  def show
    @shops = Shop.can_buy.order_by(:position => :asc).all
  end

  def wechat_test
    SlackDispatcher.new.message("NEW CODE : #{params[:code]}")
  end

  private

    def admin_redirection
      if identity_solver.potential_admin?
        redirect_to edit_admin_account_path
      end
    end

    def shopkeeper_redirection
      if identity_solver.potential_shopkeeper?
        redirect_to new_guest_shop_application_path
      end
    end
end
