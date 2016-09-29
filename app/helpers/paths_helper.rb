module PathsHelper
  def checkout_path?
    # those are the paths linked to the checkout process (from manager cart to the actual payment)
    # set_address to completely refactor (it's disgusting)
    matching_paths = [customer_cart_path, '/orders/set_address/', gateway_customer_checkout_path, payment_method_customer_checkout_path]
    matching_paths.each do |path|
      if url_for.index(path) == 0
        return true
      end
    end
    false
  end
end
