class Guest::HomeController < ApplicationController

  before_action :admin_redirection

  def show
    @shops = Shop.can_buy.order_by(:position => :asc).all
  end

  private

  def admin_redirection
    if identity_solver.potential_admin?
      redirect_to edit_admin_account_path
    end
  end

end
