module Application
  module Breadcrumb
    extend ActiveSupport::Concern

    included do
    end

    # we should put it into a library, there's an obvious possible abstraction here
    def breadcrumb_category
      add_breadcrumb @category.name, guest_category_path(@category) unless @category.nil?
    end

    def breadcrumb_shop
      add_breadcrumb @shop.shopname, guest_shop_path(@shop) unless @shop.nil?
    end

    def breadcrumb_product
      add_breadcrumb @product.name, guest_product_path(@product) unless @product.name.nil?
    end

    def breadcrumb_home
      add_breadcrumb I18n.t(:home, scope: :breadcrumb), :root_path
    end

  end
end
