class Api::Guest::TranslationsController < ApplicationController

  def index
  end

  def show
    @translation = I18n.t(valid_params[:translation_slug], :scope => valid_params[:translation_scope])
  end

  def valid_params
    params.permit(:translation_slug, :translation_scope).symbolize_keys
  end

end
