module Application
  module Breadcrumb
    extend ActiveSupport::Concern

    included do
    end

    # we should put it into a library, there's an obvious possible abstraction here
    def breadcrumb_category
      add_breadcrumb @category.name, guest_category_path(@category) unless @category.nil?
    end

    def breadcrumb_package_sets
      add_breadcrumb I18n.t(:package_sets, scope: :package_set), guest_package_sets_path
    end

    def breadcrumb_package_set
      add_breadcrumb @package_set.name, guest_package_set_path(@package_set) unless @package_set.nil?
    end

    def breadcrumb_shop
      add_breadcrumb @shop.shopname, guest_shop_path(@shop) unless @shop.nil?
    end

    def breadcrumb_product
      add_breadcrumb @product.name, guest_product_path(@product) unless @product.name.nil?
    end

    def breadcrumb_cart
      add_breadcrumb I18n.t(:my_cart, scope: :top_menu), customer_cart_path
    end

    def breadcrumb_checkout_address
      add_breadcrumb I18n.t(:my_address, scope: :top_menu), new_customer_order_address_path(order_id: @order.id) unless @order.nil?
    end

    def breadcrumb_checkout_identity
      add_breadcrumb I18n.t(:my_identity, scope: :top_menu), new_customer_order_identity_path(order_id: @order.id) unless @order.nil?
    end

    def breadcrumb_payment_method
      add_breadcrumb I18n.t(:my_payment, scope: :top_menu), payment_method_customer_checkout_path
    end

    def breadcrumb_home
      add_breadcrumb I18n.t(:home, scope: :breadcrumb), :root_path
    end

    # =====
    # SHOPKEEPER
    # =====

    def breadcrumb_shopkeeper_products
      add_breadcrumb current_user.shop.shopname, shopkeeper_products_path
    end

    def breadcrumb_shopkeeper_edit_product
      add_breadcrumb @product.name, edit_shopkeeper_product_path(@product) if @product.name
    end

    def breadcrumb_shopkeeper_product_skus
      add_breadcrumb I18n.t(:skus, scope: :breadcrumb), shopkeeper_product_skus_path(@product) if @product
    end

    def breadcrumb_shopkeeper_product_edit_sku
      add_breadcrumb I18n.t(:edit, scope: :breadcrumb), edit_shopkeeper_product_sku_path(@sku.product, @sku) if @sku
    end

    def breadcrumb_shopkeeper_product_variants
      add_breadcrumb I18n.t(:variants, scope: :breadcrumb), shopkeeper_product_variants_path(@product) if @product
    end

    # =====
    # ADMIN
    # =====

    def breadcrumb_admin_coupons
      add_breadcrumb 'Coupons', admin_coupons_path
    end

    def breadcrumb_admin_coupon
      add_breadcrumb @coupon.code, admin_coupon_path(@coupon) if @coupon
    end

    def breadcrumb_admin_coupon_edit
      add_breadcrumb 'Edit', edit_admin_coupon_path(@coupon) if @coupon
    end

    def breadcrumb_admin_coupon_new
      add_breadcrumb 'New', new_admin_coupon_path
    end

    def breadcrumb_admin_order_payments
      add_breadcrumb 'Order Payment', admin_order_payments_path
    end

    def breadcrumb_admin_order_payment
      add_breadcrumb @order_payment.id, admin_order_payment_path(@order_payment) if @order_payment
    end

    def breadcrumb_admin_carts
      add_breadcrumb'Cart', admin_carts_path
    end

    def breadcrumb_admin_cart
      add_breadcrumb @cart.id, admin_cart_path(@cart) if @cart
    end

    def breadcrumb_admin_orders
      add_breadcrumb 'Orders', admin_orders_path
    end

    def breadcrumb_admin_order
      add_breadcrumb @order.id, admin_order_path(@order) if @order
    end

    def breadcrumb_admin_referrer_groups
      add_breadcrumb 'Referrer Groups', admin_referrer_groups_path
    end

    def breadcrumb_admin_referrer_group
      add_breadcrumb @referrer_group.token, admin_referrer_group_path(@referrer_group) if @referrer_group
    end

    def breadcrumb_admin_referrer_group_edit
      add_breadcrumb 'Edit', edit_admin_referrer_group_path(@referrer_group) if @referrer_group
    end

    def breadcrumb_admin_referrer_group_new
      add_breadcrumb 'New', new_admin_referrer_group_path
    end

    def breadcrumb_admin_referrers
      add_breadcrumb 'Referrers', admin_referrers_path
    end

    def breadcrumb_admin_referrer
      add_breadcrumb @referrer.reference_id, '#' if @referrer
    end

    def breadcrumb_admin_referrer_provisions
      add_breadcrumb 'Provisions', admin_referrer_provisions_path(@referrer) if @referrer
    end

    def breadcrumb_admin_referrer_coupon
      add_breadcrumb 'Coupon', coupon_admin_referrer_coupon_path(@referrer) if @referrer
    end

    def breadcrumb_admin_users
      add_breadcrumb 'Users', admin_users_path
    end

    def breadcrumb_admin_user
      add_breadcrumb @user.decorate.full_name, admin_user_path(@user) if @user
    end

    def breadcrumb_admin_categories
      add_breadcrumb 'Categories', admin_categories_path
    end

    def breadcrumb_admin_category
      add_breadcrumb @category.name, admin_category_path(@category) if @category
    end

    def breadcrumb_admin_shops
      add_breadcrumb 'Shops', admin_shops_path
    end

    def breadcrumb_admin_shop
      add_breadcrumb @shop.shopname, admin_shop_path(@shop) if @shop
    end

    def breadcrumb_admin_shop_products
      add_breadcrumb @shop.shopname, admin_shop_products_path(@shop) if @shop
    end

    def breadcrumb_admin_edit_product
      if @product.name
        add_breadcrumb @product.name, edit_admin_shop_product_path(@product.shop, @product)
      end
    end

    def breadcrumb_admin_product_skus
      add_breadcrumb 'Skus', admin_shop_product_skus_path(@product.shop, @product) if @product
    end

    def breadcrumb_admin_product_edit_sku
      if @sku
        add_breadcrumb 'Edit', edit_admin_shop_product_sku_path(@sku.product.shop, @sku.product, @sku)
      end
    end

    def breadcrumb_admin_product_variants
      add_breadcrumb 'Variants', admin_shop_product_variants_path(@product.shop, @product) if @product
    end
  end
end
