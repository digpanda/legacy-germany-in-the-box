# asynchronous translation catcher for front-end purpose
# it's used in the Translation model in the front-end system.
# NOTE : the prefered way it the HTML injection + catch from library right now
# this AJAX system sadly make too many aysnchronous call and force callbacks everywhere which i want to avoid
# - Laurent
class Api::Guest::TranslationsController < Api::ApplicationController
  def index
  end

  def show
    @translation = I18n.t("#{valid_params[:translation_scope]}.#{valid_params[:translation_slug]}")
  end

  private

    def valid_params
      params.permit(:translation_slug, :translation_scope).symbolize_keys
    end
end
