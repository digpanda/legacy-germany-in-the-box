class Api::ApplicationController < ApplicationController

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :throw_page_not_found

  def throw_page_not_found
    render status: :not_found,
           json: throw_error(:page_not_found).to_json and return
  end

end