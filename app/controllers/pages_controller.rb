class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide, :fees, :menu, :customer_guide]

  def home
    @categories = Category.all
  end

  def agb
  end

  def privacy
  end

  def imprint
  end

  def saleguide
  end

  def sending_guide
  end

  def customer_guide
  end
  
  def fees
  end

  def menu
  end

end

