class AdyenController < ActionController::Base

  def index
    redirect_to adyen_url
  end

  def callback
    binding.pry
  end

  private

  def adyen_url
    Adyen::Form.redirect_url(
      :shopper_locale => 'zh_CN',
      :country_code => 'CN',
      :currency_code => 'CNY',
      :ship_before_date => Date.today,
      :session_validity => Time.now,
      :merchant_reference => 'SKINTEST-1482235768306',
      :merchant_account => 'DigpandaCN',
      :skin_code => ENV['adyen_skin'],
      :shared_secret => ENV['adyen_shared_secret'],
      :payment_amount => 30 * 100, # cents
      :res_URL => adyen_callback_path
    )
  end

end
