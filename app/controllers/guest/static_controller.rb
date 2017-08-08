class Guest::StaticController < ApplicationController
  # here are all the static redirection made in the project
  def xipost
    redirect_to Xipost.identity_remote_url
  end
end
