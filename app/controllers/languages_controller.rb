class LanguagesController < ActionController::Base # No application because it's a standalone service

  include UsersHelper
  include NavigationHistoryHelper
  include ErrorsHelper

  ACCEPTED_LANGUAGES = ["zh-CN", "de"]

  def update

    throw_app_error(:bad_language) and return unless valid_params?

    session[:locale] = language_params[:id]

    redirect_to navigation_history(1) and return if seems_like_an_admin? # go back in case of admin
    redirect_to root_url and return

  end

  private

  def language_params
    params.permit(:id)
  end

  def valid_params?
    ACCEPTED_LANGUAGES.include? language_params[:id] # small validation, could be put within a model without database
  end

  # NOT CURRENTLY IN USE
  def extract_locale
    request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : 'de'
  end

end