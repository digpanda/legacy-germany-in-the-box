class LanguagesController < ActionController::Base # No application because it's a standalone service

  include UsersHelper
  include ErrorsHelper

  include Rails.application.routes.url_helpers

  ACCEPTED_LANGUAGES = %w(zh-CN de)
  ACCEPTED_LOCATIONS = [Rails.application.routes.url_helpers.new_user_session_path]

  def update

    throw_app_error(:bad_language) and return unless valid_language? && valid_location?

    session[:locale] = language_params[:id]

    redirect_to language_params[:location] and return if language_params[:location] # go to whatever location is authorized
    redirect_to NavigationHistory.new(request, session).back(1) and return if potential_admin? # go back on the current page in case of admin
    redirect_to root_url and return

  end

  private

  def language_params
    params.permit(:id, :location)
  end

  def valid_language?
    ACCEPTED_LANGUAGES.include? language_params[:id] # small validation, could be put within a model without database
  end

  def valid_location?
    (ACCEPTED_LOCATIONS.include? language_params[:location]) || language_params[:location].nil? # valid location or nil
  end

  # NOT CURRENTLY IN USE
  def extract_locale
    request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : 'de'
  end

end