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
    redirect_to link.raw_url
  end
  
  # NOTE
  # this enforce the login even if the user is already logged-in within wechat
  # (it has been problematic for some reason when we tried to remove it.)
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
