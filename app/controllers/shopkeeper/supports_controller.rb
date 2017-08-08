class Shopkeeper::SupportsController < ApplicationController
  authorize_resource class: false

  layout :custom_sublayout, only: [:index]

  def index
  end
end
