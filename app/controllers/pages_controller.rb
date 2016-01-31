class PagesController < ApplicationController

  skip_before_filter :authenticate_user!, only: :home

  def home
  end

end

