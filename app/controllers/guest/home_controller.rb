require 'actionpack/action_caching'

class Guest::HomeController < ApplicationController
  before_filter :admin_redirection, :shopkeeper_redirection

  caches_action :show

  def show
    SlackDispatcher.new.message("EVENT DISPATCHER WILL BE TRIGGERED VIA SIDEKIQ NOW")
    EventDispatcher.new.test
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
