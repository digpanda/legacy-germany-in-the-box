module Application
  module Devise
    extend ActiveSupport::Concern

    included do
    end

    # NOTE : it's in a concern but it should also be abstracted into a service or something. it's way too big.

    # NOTE : this should be placed into a module linked to the login / subscription
    # this is a devise hook. we basically check the kind of customer and redirect
    # there can be forced redirection if the user tried to access a forbidden area
    # and was redirected to the login side
    # TODO : this should definitely be refactored into a clean class
    # but it's alright for now
    def after_sign_in_path_for(resource)

      if current_user.customer?
        force_chinese!

        # we must remove the empty orders in case they exist
        # NOTE : normally it shouldn't happen in the normal behaviour
        # but it appeared sometimes for some unknown reason
        # and made people blow up on sign-in
        remove_all_empty_orders!

        # we get the last order which's not paid yet
        last_order = current_user.orders.unpaid.order_by(:u_at => :desc).first
        if last_order
          cart_manager.store(last_order)
        end

        return navigation.force! if navigation.force?
        return navigation.back(1)
      end

      # if the person is not a customer
      # he doesn't need any order.
      remove_all_orders!

      if current_user.shopkeeper?
        force_german!
        if current_user.shop.agb
          return shopkeeper_orders_path
        end
        return navigation.force! if navigation.force?
        return shopkeeper_shop_producer_path
      end

      if current_user.admin?
        return navigation.force! if navigation.force?
        return admin_shops_path
      end

    end

    private

    def remove_all_orders!
      current_user.orders.each do |order|
        order.order_items.delete_all
        order.delete
      end
    end

    def remove_all_empty_orders!
      current_user.orders.each do |order|
        if order.order_items.count == 0
          order.delete
        end
      end
    end

    # def authenticate_user_with_force!
    #   NavigationHistory.new(request, session).store(:current, :force)
    #   authenticate_user!
    # end

  end
end
