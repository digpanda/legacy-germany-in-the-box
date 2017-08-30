class Guest::LinksController < ApplicationController
  attr_reader :referrer, :link

  before_action :set_link, only: [:show, :weixin]
  before_action :set_referrer, only: [:weixin]

  # NOTE
  # the cycling of this system has been simplified lately
  # users from wechat are systematically logged-in
  # during this process it keeps all the parameters
  # if `reference_id` is present we attempt a binding
  # after this binding we redirect the user to raw_url below
  def show
    SlackDispatcher.new.message("REDIRECT TO RAW URL NOW")
    redirect_to link.raw_url
  end

  # LEGACY NOTE
  # this is a legacy / obsolete system which is used in some of our current links
  # the goal of this method was to auto-login
  # when the login wasn't forced everywhere to wechat users
  # it could be removed after a while.
  # Laurent, 29/08/2017
  def weixin
    redirect_to link.wechat.with_referrer(referrer)
    # show
  end

  private

    def set_referrer
      @referrer = Referrer.where(reference_id: params[:reference_id]).first
    end

    def set_link
      @link = Link.find(params[:link_id] || params[:id])
    end
end
