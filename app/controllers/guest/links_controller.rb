class Guest::LinksController < ApplicationController
  attr_reader :referrer, :link

  before_action :set_link, only: [:show, :weixin]
  before_action :set_referrer, only: [:weixin]

  # NOTE
  # the cycling of this system is very complex.
  # the admin create a new Link
  # the referrer then get a weixin link provided with a redirect_uri defined as this controller as target
  # the guest using the link provided by the referrer will be redirect on our site
  # will be logged-in and bind to a referrer
  # then will go down this controller to be redirected to the original link.
  def show
    redirect_to link.raw_url
  end

  # it's another layer which will automatically get people to go
  # in the auto-login system (by weixin)
  # and then comes back to the raw link right above (#show)
  # # NOTE : we could extend the force login
  # to the whole system at some point, everything is ready for it (url generator, etc.)
  def weixin
    redirect_to link.wechat.with_referrer(referrer)
  end

  private

    def set_referrer
      @referrer = Referrer.where(reference_id: params[:reference_id]).first
    end

    def set_link
      @link = Link.find(params[:link_id] || params[:id])
    end
end
