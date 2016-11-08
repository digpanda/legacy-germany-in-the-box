require 'base64_to_upload'
require 'border_guru'

class ApplicationController < ActionController::Base

  include HttpAcceptLanguage::AutoLocale

  include UsersHelper
  include WickedPdfHelper
  include ErrorsHelper
  include LanguagesHelper

  include Mobvious::Rails::Controller

  before_action :setup_request

  # this variable setup is very sensitive
  # we use it in exceptional context
  # please be aware of how it works before to use it
  def setup_request
    $request = request
  end

  # handle hard exception (which will throw a page error)
  # and soft ones even on dev / test (which will usually redirect the customer)
  unless Rails.env.development?

    around_action :hard_exception_handler

    def hard_exception_handler
      yield
    rescue Mongoid::Errors::DocumentNotFound => exception
      throw_resource_not_found
    rescue Exception => exception
      throw_server_error_page
    ensure
      dispatch_error_email(exception)
    end

  end

  around_action :soft_exception_handler

  def soft_exception_handler
    yield
  rescue CanCan::AccessDenied
    throw_unauthorized_page
  end

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format.html? }

  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }, :fallback => :none

  before_action :set_current_language

  helper_method :cart_manager, :total_number_of_products

  around_action :set_translation_locale, only: [:update], if: -> { current_user&.decorate&.admin? }

  before_action :set_categories

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  protected

  def authenticate_user_with_force!
    NavigationHistory.new(request, session).store(:current, :force)
    authenticate_user!
  end

  def navigation
    @navigation ||= NavigationHistory.new(request, session)
  end

  def set_categories
    if potential_customer?
      @categories = Category.order(position: :asc).all
    end
  end

  def custom_sublayout
    "sublayout/_menu"
  end

  def cart_manager
    @cart_manager ||= CartManager.new(session, current_user)
  end

  # put this too inside the CartManager or something
  def total_number_of_products
    cart_manager.products_number
  end

  # NOTE : this should be placed into a module linked to the login / subscription
  # this is a devise hook. we basically check the kind of customer and redirect
  # there can be forced redirection if the user tried to access a forbidden area
  # and was redirected to the login side
  # TODO : this should definitely be refactored into a clean class
  # but it's alright for now
  def after_sign_in_path_for(resource)

    if current_user.decorate.customer?
      force_chinese!
      return navigation.force! if navigation.force?
      return navigation.back(1)
    end

    # if the person is not a customer
    # he doesn't need any order.
    remove_all_orders!

    if current_user.decorate.shopkeeper?
      force_german!
      if current_user.shop.agb
        return shopkeeper_orders_path
      end
      return navigation.force! if navigation.force?
      return shopkeeper_shop_producer_path
    end

    if current_user.decorate.admin?
      return navigation.force! if navigation.force?
      return admin_shops_path
    end

  end

  def remove_all_orders!
    current_user.orders.each do |order|
      order.order_items.delete_all
      order.delete
    end
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

  private

  # cancancan hook
  def current_ability
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join('/').camelize
    Ability.new(current_user, controller_namespace)
  end

end
