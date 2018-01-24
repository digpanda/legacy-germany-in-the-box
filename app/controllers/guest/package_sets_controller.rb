class Guest::PackageSetsController < ApplicationController
  attr_reader :package_set, :category, :brand

  before_filter do
    restrict_to :customer
  end

  before_action :set_package_set, :set_category, :set_brand
  before_action :set_banner, only: [:index, :categories]

  def show
  end

  def categories
    @categories = Category.showable.with_package_sets.order_by(position: :asc)
    @brand_filters = Brand.with_package_sets.order_by(position: :asc).used_as_filters
    @services_brand_filters = Brand.with_services.order_by(position: :asc).used_as_filters
  end

  # we show the list of package by category
  # otherwise we redirect the user to the /categories area
  def index

    @package_sets = PackageSet.active.order_by(position: :asc)

    # category querying
    if category
      @package_sets = @package_sets.with_category(category)
    end

    # brand querying
    if brand
      @package_sets = @package_sets.with_brand(brand)
    end

    # if there's no brand and category
    # we redirect to the category landing page
    unless valid_filters?
      redirect_to guest_package_sets_categories_path
      return
    end

    @package_sets = @package_sets.all

    # now we manage the brand filters
    # if we are in a specific category
    # we just get the category brands
    if category
      @brand_filters = category.package_sets_brands.order_by(position: :asc).used_as_filters
    else
      @brand_filters = Brand.with_package_sets.order_by(position: :asc).used_as_filters
    end
  end

  def promote_qrcode
    SlackDispatcher.new.message("HIT PROMOTE QRCODE")
    send_data blob_qrcode, stream: 'false', filename: 'qrcode.jpg', type: 'image/jpeg', disposition: 'inline'
  end

  private

    def blob_qrcode
      if current_user&.referrer
        url_with_reference = guest_package_set_url(package_set, reference_id: current_user&.referrer&.reference_id)
        force_login_url = WechatUrlAdjuster.new(url_with_reference).adjusted_url
        SlackDispatcher.new.message("FORCE LOGIN URL #{force_login_url}")
        qrcode_path = SmartQrcode.new(force_login_url).perform
        Flyer.new.process_cover_qrcode(package_set.cover, qrcode_path).image.to_blob
      end
    end

    def valid_filters?
      category || brand || params[:category_id] == 'all'
    end

    def order
      @order ||= cart_manager.order(shop: package_set.shop)
    end
    # end of abstraction

    def set_banner
      @banner = Banner.active.where(location: :package_sets_landing_cover).first
    end

    def set_package_set
      @package_set = PackageSet.find(params[:id] || params[:package_set_id]) if params[:id] || params[:package_set_id]
    end

    # for filtering (optional)
    def set_category
      # NOTE : we cannot remove `category_slug` as it is used in old articles people still click on
      # please keep the variable but avoid to use it anymore while sharing links.
      # Laurent, 04/09/2017
      params[:category_id] = params[:category_slug] if params[:category_slug]
      if params[:category_id]
        begin
          @category = Category.find(params[:category_id])
        rescue Mongoid::Errors::DocumentNotFound
          # we need to rescue to avoid crashing the application
          # in case the id does not match anything real (like `all`)
        end
      end
    end

    # for filtering (optional)
    def set_brand
      if params[:brand_id]
        begin
          @brand = Brand.find(params[:brand_id])
        rescue Mongoid::Errors::DocumentNotFound
          # we need to rescue to avoid crashing the application
          # like for the category_id above
        end
      end
    end
end
