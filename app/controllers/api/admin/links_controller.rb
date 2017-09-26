class Api::Admin::LinksController < Api::ApplicationController
  authorize_resource class: false

  def wechat
    adjusted_url = WechatUrlAdjuster.new(params[:raw_url]).adjusted_url

    render status: :ok,
          json: { success: true, data: { adjusted_url: adjusted_url } }.to_json
  end
end
