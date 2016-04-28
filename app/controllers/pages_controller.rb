class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide]

  acts_as_token_authentication_handler_for User, except: [:home, :privacy, :imprint, :saleguide]

  #load_and_authorize_resource :class => false

  def home

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

