module PathsHelper

  def vuejs_path
    "https://unpkg.com/vue"
  end

  def resolve_profile_path
    if current_user
      if current_user.decorate.new_notifications?
        shared_notifications_path
      else
        edit_customer_account_path
      end
    else
      new_user_session_path
    end
  end

  def checkout_path?
    # those are the paths linked to the checkout process (from manager cart to the actual payment)
    # set_address to completely refactor (it's disgusting) # -> replaced '/orders/set_address/'
    # customer_order_addresses_path <-- we should include it for the set address on checkout
    # but there's a path problem, let's see if it causes problem first and find a solution later
    matching_paths = [customer_cart_path, gateway_customer_checkout_path, payment_method_customer_checkout_path]
    matching_paths.each do |path|
      if url_for.index(path) == 0
        return true
      end
    end
    false
  end
end
