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

    def breadcrumb_admin_shops
      add_breadcrumb "Shops", admin_shops_path
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
      add_breadcrumb "Skus", admin_shop_product_skus_path(@product.shop, @product) if @product
    end

    def breadcrumb_admin_product_edit_sku
      if @sku
        add_breadcrumb "Edit", edit_admin_shop_product_sku_path(@sku.product.shop, @sku.product, @sku)
      end
    end

    def breadcrumb_admin_product_variants
      add_breadcrumb "Variants", admin_shop_product_variants_path(@product.shop, @product) if @product
    end
  end
end
