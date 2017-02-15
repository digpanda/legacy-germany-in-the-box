class Admin::ReferrersController < ApplicationController

  attr_accessor :referrer, :referrers

  authorize_resource :class => false
  layout :custom_sublayout

  def index
    @referrers = User.with_referrer
  end

  def new
    @referrer_token = ReferrerToken.create
  end

end
