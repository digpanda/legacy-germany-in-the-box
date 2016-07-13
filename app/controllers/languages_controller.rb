class LanguagesController < ActionController::Base # No application because it's a standalone service

  include UsersHelper
  include NavigationHistoryHelper
  include ErrorsHelper

  def update

    render status: :bad_request,
             json: throw_error(:bad_language).to_json and return unless valid_params?

    session[:locale] = language_params[:id]

    navigation_history(1) and return if seems_like_an_admin? # go back in case of admin
    redirect_to root_url and return

  end

  private

  def language_params
    params.permit(:id)
  end

  def valid_params?
    ["zh-CN", "de"].include? language_params[:id] # small validation, could be put within a model without database
  end

end