class Guest::PagesController < ApplicationController
  # NOTE : the related sections should be placed into authenticated sections
  # but for convenience we keep it here for now. If the conditions get big, please switch
  # - Laurent
  before_action :authenticate_user!, only: [:agb, :sending_guide]

  def business_model
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

  def customer_about
  end

  def customer_qa
  end

  def shipping_cost
  end

  def fees
  end

  def publicity
  end
end
