class Shopkeeper::SupportsController < ApplicationController

  load_and_authorize_resource :class => false
  layout :custom_sublayout, only: [:index]

  def index
  end

end