class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide, :fees, :menu, :customer_guide, :customer_agb, :customer_qa]

  def home
    @categories = Category.all
    binding.pry
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

  def customer_agb
  end

  def customer_qa
  end

  def fees
  end

  def menu
  end

end
