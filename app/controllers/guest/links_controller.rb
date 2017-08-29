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
    SlackDispatcher.new.message("SHOW LINK IS HERE, IT SHOULD BE USED AFTER EVERYTHING ELSE TO SHOW THE REAL LINK.")
    redirect_to link.raw_url
  end

  # it's another layer which will automatically get people to go
  # in the auto-login system (by weixin)
  # TODO : this system is now obsolete since any wechat user
  # will be automatically logged-in before to reach any page of the site
  # this should be fully tested (slackdispatcher to check everything goes in order)
  # and become an alias of #show (legacy reason)
  def weixin
    SlackDispatcher.new.message("WEIXIN WAS REACHED AND WILL REDIRECT TO THE AUTO LOGIN NOW")
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
