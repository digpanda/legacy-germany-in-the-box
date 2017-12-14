module Application
  module Breadcrumb
    extend ActiveSupport::Concern

    included do
    end

    protected

      def breadcrumb_admin_inquiries
        breadcrumb :admin, :inquiries
      end

      def breadcrumb_admin_inquiry
        breadcrumb :admin, @inquiry
      end

      def breadcrumb_admin_links
        breadcrumb :admin, :links
      end

      def breadcrumb_admin_link
        breadcumb :admin, @link
      end

      def breadcrumb_admin_link_edit
        breadcrumb :admin, @link, :edit
      end

      def breadcrumb_admin_link_new
        breadcrumb :admin, :links, :new
      end

      def breadcrumb_admin_banners
        breadcrumb :admin, :banners
      end

      def breadcrumb_admin_banner
        breadcrumb :admin, @banner
      end

      def breadcrumb_admin_banner_edit
        breadcrumb :admin, @banner, :edit
      end

      def breadcrumb_admin_banner_new
        breadcrumb :admin, :banners, :new
      end

      def breadcrumb_admin_coupons
        breadcrumb :admin, :coupons
      end

      def breadcrumb_admin_coupon
        breadcrumb :admin, @coupon
      end

      def breadcrumb_admin_coupon_edit
        breadcrumb :admin, @coupon, :edit
      end

      def breadcrumb_admin_coupon_new
        breadcrumb :admin, :coupons, :new
      end

      def breadcrumb_admin_order_payments
        breadcrumb :admin, :order_payments
      end

      def breadcrumb_admin_order_payment
        breadcrumb :admin, @order_payment
      end

      def breadcrumb_admin_carts
        breadcrumb :admin, :carts
      end

      def breadcrumb_admin_cart
        breadcrumb :admin, @cart
      end

      def breadcrumb_admin_orders
        breadcrumb :admin, :orders
      end

      def breadcrumb_admin_order
        breadcrumb :admin, @order
      end

      def breadcrumb_admin_referrer_groups
        breadcrumb :admin, :referrer_groups
      end

      def breadcrumb_admin_referrer_group
        breadcrumb :admin, @referrer_group
      end

      def breadcrumb_admin_referrer_group_edit
        breadcrumb :admin, @referrer_group, :edit
      end

      def breadcrumb_admin_referrer_group_new
        breadcrumb :admin, @referrer_group, :new
      end

      def breadcrumb_admin_referrers
        breadcrumb :admin, :referrers
      end

      def breadcrumb_admin_referrer
        breadcrumb :admin, @referrer
      end

      def breadcrumb_admin_referrer_provision
        breadcrumb :admin, @provision
      end

      def breadcrumb_admin_users
        breadcrumb :admin, :users
      end

      def breadcrumb_admin_user
        breadcrumb :admin, @user
      end

      def breadcrumb_admin_categories
        breadcrumb :admin, :categories
      end

      def breadcrumb_admin_category
        breadcrumb :admin, @category
      end

      def breadcrumb_admin_brands
        breadcrumb :admin, :brands
      end

      def breadcrumb_admin_brand
        breadcrumb :admin, @brand
      end

      def breadcrumb_admin_brand_edit
        breadcrumb :admin, @brand, :edit
      end

      def breadcrumb_admin_shops
        breadcrumb :admin, :shops
      end

      def breadcrumb_admin_shop
        breadcrumb :admin, @shop
      end

      def breadcrumb_admin_referrer_provisions
        # TODO : this can't be solved right now.
        add_breadcrumb 'Provisions', admin_referrer_provisions_path(@referrer) if @referrer
      end

      def breadcrumb_admin_shop_products
        # TODO : this can't be solved right now.
        add_breadcrumb @shop.shopname, admin_shop_products_path(@shop) if @shop
      end

      def breadcrumb_admin_referrer_coupon
        # TODO : this can't be solved right now.
        add_breadcrumb 'Coupon', coupon_admin_referrer_coupon_path(@referrer) if @referrer
      end

      def breadcrumb_admin_edit_product
        # TODO : this can't be solved right now.
        if @product.name
          add_breadcrumb @product.name, edit_admin_shop_product_path(@product.shop, @product)
        end
      end

      def breadcrumb_admin_product_skus
        # TODO : this can't be solved right now.
        add_breadcrumb 'Skus', admin_shop_product_skus_path(@product.shop, @product) if @product
      end

      def breadcrumb_admin_product_edit_sku
        # TODO : this can't be solved right now.
        if @sku
          add_breadcrumb 'Edit', edit_admin_shop_product_sku_path(@sku.product.shop, @sku.product, @sku)
        end
      end

      def breadcrumb_admin_product_variants
        # TODO : this can't be solved right now.
        add_breadcrumb 'Variants', admin_shop_product_variants_path(@product.shop, @product) if @product
      end

      # generation of the breadcrumb
      # in a simplier way
      def breadcrumb(namespace, resource, action = nil)
        return unless resource

        if resource.instance_of? Symbol
          controller = resource
        else
          controller = resource.class.to_s.downcase.pluralize
        end

        if action
          title = action.to_s.capitalize
        else
          if resource.instance_of? Symbol
            title = resource.to_s.gsub('_', ' ').capitalize
          else
            if resource.respond_to?(:title)
              title = resource.title
            elsif resource.respond_to?(:name)
              title = resource.name
            elsif resource.respond_to?(:id)
              title = resource.id
            else
              title = resource
            end
          end
        end

        if resource.instance_of? Symbol
          path = polymorphic_url([namespace, controller, action], only_path: true)
        else
          path = polymorphic_url([namespace, resource], only_path: true)
        end
        add_breadcrumb title, path
      end

  end
end
