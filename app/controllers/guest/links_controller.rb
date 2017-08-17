class Guest::LinksController < ApplicationController
  attr_reader :link

  before_action :set_link

  # NOTE
  # the cycling of this system is very complex.
  # the admin create a new Link
  # the referrer then get a weixin link provided with a redirect_uri defined as this controller as target
  # the guest using the link provided by the referrer will be redirect on our site
  # will be logged-in and bind to a referrer
  # then will go down this controller to be redirected to the original link.
  def show
    SlackDispatcher.new.message("GUEST LINK IS : #{link.raw_url}")
    redirect_to link.raw_url
  end

  private

    def set_link
      @link = Link.find(params[:id])
    end
end
