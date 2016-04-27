class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide]

  acts_as_token_authentication_handler_for User, except: [:home, :privacy, :imprint, :saleguide]

  #load_and_authorize_resource :class => false

  def home
  
=begin  
    THIS IS FOR TESTING PURPOSE, DON'T UNCOMMENT IT - Laurent
    @wirecard = Wirecard.new({

      :merchant_id => "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a",
      :secret_key => "6cbfa34e-91a7-421a-8dde-069fc0f5e0b8",
      :username => "engine.digpanda",
      :password => "x3Zyr8MaY7TDxj6F"

    })
=end

  end

  def agb
  	render :layout => false
  end

  def privacy
  	render :layout => false
  end

  def imprint
  	render :layout => false
  end

  def saleguide
  	render :layout => false
  end
  
  def fees
  	render :layout => false
  end
end

