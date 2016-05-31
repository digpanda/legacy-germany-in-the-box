class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide, :fees, :menu]

  #acts_as_token_authentication_handler_for User, except: [:home, :privacy, :imprint, :saleguide, :demo, :menu]

  #load_and_authorize_resource :class => false

  def home
    #@products = Product.buyable.all
    @shops = Shop.with_buyable_products.all
  end

  def agb
  end

  def privacy
  end

  def imprint
  end

  def saleguide
  end
  
  def fees
  end

  def menu
  end

end

