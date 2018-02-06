class LanguagesController < ActionController::Base # No application because it's a standalone service
  include IdentityHelper
  include ErrorsHelper

  include Rails.application.routes.url_helpers

  ACCEPTED_LANGUAGES = %w(zh-CN de).freeze
  ACCEPTED_LOCATIONS = [Rails.application.routes.url_helpers.new_user_session_path].freeze

  before_action :identity_solver

  # for get redirections
  def show
    update
  end

  def update
    unless valid_language? && valid_location?
      throw_app_error(:bad_language)
      return
    end

    if language_params[:sign_out]
      sign_out
    end

    session[:locations] = params[:locations]
    session[:locale] = language_params[:id]

    if language_params[:location] # go to whatever location is authorized
      redirect_to language_params[:location]
    elsif potential_admin? # go back on the current page in case of admin
      redirect_to NavigationHistory.new(request, session).back(1)
    else
      redirect_to root_url
    end
  end

  private

    def language_params
      params.permit(:id, :location, :sign_out, :su)
    end

    def valid_location?
      (ACCEPTED_LOCATIONS.include? language_params[:location]) || language_params[:location].nil? # valid location or nil
    end
    
    def valid_language?
      ACCEPTED_LANGUAGES.include? language_params[:id] # small validation, could be put within a model without database
    end


    # NOTE : this was duplicated from `application_controller.rb` as this controller
    # does not inherit from it but use this functionality
    def identity_solver
      @identity_solver ||= IdentitySolver.new(request, current_user)
    end

    # this is not currently in used in the system but could be re-used someday
    def extract_locale
      request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : 'de'
    end
end
