require 'actionpack/action_caching'

class Guest::HomeController < ApplicationController
  before_filter :admin_redirection, :shopkeeper_redirection

  # caches_action :show

  def show
    10.times do |t|
      SlackDispatcher.new.message("DISPATCH ORDER #{t}")
    end
    @shops = Shop.can_buy.order_by(position: :asc).all
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
