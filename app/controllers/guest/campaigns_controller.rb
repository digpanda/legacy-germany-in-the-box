class Guest::CampaignsController < ApplicationController

  before_filter :production_only

  def index
    tampons
  end

  def tampons
    redirect_to guest_shop_path(Shop.find("574182a13fd235119bcbf76e"))
  end

  private

  def production_only
    unless Rails.env.production? || Rails.env.staging?
      flash[:error] = "You must be on the real site to access this area."
      redirect_to navigation.back(1)
    end
  end

end
