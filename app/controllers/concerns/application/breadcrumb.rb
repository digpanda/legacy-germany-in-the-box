module Application
  module Breadcrumb
    extend ActiveSupport::Concern

    included do
    end

    protected

      # =====
      # ADMIN
      # =====
      #

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

      def breadcrumb_admin_inquiries
        breadcrumb :admin, :inquiries
        #add_breadcrumb 'Inquiries', admin_inquiries_path
      end

      def breadcrumb_admin_inquiry
        breadcrumb :admin, @inquiry
        # add_breadcrumb @inquiry.id, admin_inquiry_path(@inquiry) if @inquiry
      end

      def breadcrumb_admin_links
        breadcrumb :admin, :links
        # OLD
        # add_breadcrumb 'Links', admin_links_path
      end

      def breadcrumb_admin_link
        breadcumb :admin, @link
        # add_breadcrumb @link.title, admin_link_path(@link) if @link
      end

      def breadcrumb_admin_link_edit
        # NEW :
        breadcrumb :admin, @link, :edit
        # OLD :
        # add_breadcrumb 'Edit', edit_admin_link_path(@link) if @link
      end

      def breadcrumb_admin_link_new
        # NEW :
        breadcrumb :admin, :links, :new
        # OLD :
        # add_breadcrumb 'New', new_admin_link_path
      end

      def breadcrumb_admin_banners
        breadcrumb :admin, :banners
        # OLD :
        # add_breadcrumb 'Banners', admin_banners_path
      end

      def breadcrumb_admin_banner
        breadcrumb :admin, @banner
        # OLD :
        # add_breadcrumb @banner.id, admin_banner_path(@banner) if @banner
      end

      def breadcrumb_admin_banner_edit
        breadcrumb :admin, @banner, :edit
        # add_breadcrumb 'Edit', edit_admin_banner_path(@banner) if @banner
      end

      def breadcrumb_admin_banner_new
        breadcrumb :admin, :banners, :new
        # add_breadcrumb 'New', new_admin_link_path
      end

      def breadcrumb_admin_coupons
        breadcrumb :admin, :coupons
        # add_breadcrumb 'Coupons', admin_coupons_path
      end

      def breadcrumb_admin_coupon
        breadcrumb :admin, @coupon
        # add_breadcrumb @coupon.code, admin_coupon_path(@coupon) if @coupon
      end

      def breadcrumb_admin_coupon_edit
        breadcrumb :admin, @coupon, :edit
        # add_breadcrumb 'Edit', edit_admin_coupon_path(@coupon) if @coupon
      end

      def breadcrumb_admin_coupon_new
        breadcrumb :admin, :coupons, :new
        # add_breadcrumb 'New', new_admin_coupon_path
      end

      def breadcrumb_admin_order_payments
        breadcrumb :admin, :order_payments
        # add_breadcrumb 'Order Payment', admin_order_payments_path
      end

      def breadcrumb_admin_order_payment
        breadcrumb :admin, @order_payment
        # add_breadcrumb @order_payment.id, admin_order_payment_path(@order_payment) if @order_payment
      end

      def breadcrumb_admin_carts
        breadcrumb :admin, :carts
        # add_breadcrumb 'Cart', admin_carts_path
      end

      def breadcrumb_admin_cart
        breadcrumb :admin, @cart
        # add_breadcrumb @cart.id, admin_cart_path(@cart) if @cart
      end

      def breadcrumb_admin_orders
        breadcrumb :admin, :orders
        # add_breadcrumb 'Orders', admin_orders_path
      end

      def breadcrumb_admin_order
        breadcrumb :admin, @order
        # add_breadcrumb @order.id, admin_order_path(@order) if @order
      end

      def breadcrumb_admin_referrer_groups
        breadcrumb :admin, :referrer_groups
        # add_breadcrumb 'Referrer Groups', admin_referrer_groups_path
      end

      def breadcrumb_admin_referrer_group
        breadcrumb :admin, @referrer_group
        # add_breadcrumb @referrer_group.token, admin_referrer_group_path(@referrer_group) if @referrer_group
      end

      def breadcrumb_admin_referrer_group_edit
        breadcrumb :admin, @referrer_group, :edit
        # add_breadcrumb 'Edit', edit_admin_referrer_group_path(@referrer_group) if @referrer_group
      end

      def breadcrumb_admin_referrer_group_new
        breadcrumb :admin, @referrer_group, :new
        # add_breadcrumb 'New', new_admin_referrer_group_path
      end

      def breadcrumb_admin_referrers
        breadcrumb :admin, :referrers
        # add_breadcrumb 'Referrers', admin_referrers_path
      end

      def breadcrumb_admin_referrer
        breadcrumb :admin, @referrer
        # add_breadcrumb @referrer.reference_id, admin_referrer_path(@referrer) if @referrer
      end

      def breadcrumb_admin_referrer_provisions
        # TODO : this can't be solved right now.
        add_breadcrumb 'Provisions', admin_referrer_provisions_path(@referrer) if @referrer
      end

      def breadcrumb_admin_referrer_provision
        breadcrumb :admin, @provision
        # add_breadcrumb @provision.id, '#' if @provision
      end

      def breadcrumb_admin_referrer_coupon
        # TODO : this can't be solved right now.
        add_breadcrumb 'Coupon', coupon_admin_referrer_coupon_path(@referrer) if @referrer
      end

      def breadcrumb_admin_users
        breadcrumb :admin, :users
        # add_breadcrumb 'Users', admin_users_path
      end

      def breadcrumb_admin_user
        breadcrumb :admin, @user
        # add_breadcrumb @user.decorate.full_name, admin_user_path(@user) if @user
      end

      def breadcrumb_admin_categories
        breadcrumb :admin, :categories
        # add_breadcrumb 'Categories', admin_categories_path
      end

      def breadcrumb_admin_category
        breadcrumb :admin, @category
        # add_breadcrumb @category.name, admin_category_path(@category) if @category
      end

      def breadcrumb_admin_brands
        breadcrumb :admin, :brands
        # add_breadcrumb 'Brands', admin_brands_path
      end

      def breadcrumb_admin_brand
        breadcrumb :admin, @brand
        # add_breadcrumb @brand.name, admin_brand_path(@brand) if @brand
      end

      def breadcrumb_admin_brand_edit
        breadcrumb :admin, @brand, :edit
        # add_breadcrumb 'Edit', edit_admin_brand_path(@brand) if @brand
      end

      def breadcrumb_admin_shops
        breadcrumb :admin, :shops
        # add_breadcrumb 'Shops', admin_shops_path
      end

      def breadcrumb_admin_shop
        breadcrumb :admin, @shop
        # add_breadcrumb @shop.shopname, admin_shop_path(@shop) if @shop
      end

      def breadcrumb_admin_shop_products
        # TODO : this can't be solved right now.
        add_breadcrumb @shop.shopname, admin_shop_products_path(@shop) if @shop
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
  end
end
