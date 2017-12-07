class Api::Admin::ExchangeRateController < Api::ApplicationController

  authorize_resource class: false

  def show
    render status: :ok,
          json: { success: true, data: { to_yuan: to_yuan, to_euro: to_euro } }.to_json
  end

  private

  def to_yuan
    Setting.instance.exchange_rate_to_yuan
  end

  def to_euro
    1 / Setting.instance.exchange_rate_to_yuan
  end

end
