class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home]

  acts_as_token_authentication_handler_for User, except: [:home]

  #load_and_authorize_resource :class => false

  def home
  end

end

