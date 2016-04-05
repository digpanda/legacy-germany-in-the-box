class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home]

  acts_as_token_authentication_handler_for User, except: [:home]

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

  def shopguide
  	render :layout => false
  end

end

