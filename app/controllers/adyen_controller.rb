class AdyenController < ActionController::Base

  AMOUNT = 30 * 100 # in cents
  REFERENCE = 'Order Number 0'

  def show
    redirect_to adyen_url
  end

  def callback
    payment_method = params[:paymentMethod]
    psp_reference = params[:pspReference]
    merchant_signature = params[:merchantSig]
    auth_result = params[:authResult] # status of transaction
    # {"merchantReference"=>"SKINTEST-1482235768306",
    # "skinCode"=>"Bsot7GRa",
    # "shopperLocale"=>"zh_CN",
    # "paymentMethod"=>"visa",
    # "authResult"=>"AUTHORISED",
    # "pspReference"=>"8614822538298083",
    # "merchantSig"=>"WU7JEnS4DMlE/p7WK5XklDzGw2Q=",
    # "controller"=>"adyen",
    # "action"=>"callback"}
    #
#     AUTHORISED: the payment authorisation was successfully completed
# REFUSED: the payment was refused. Payment authorisation was unsuccessful.
# CANCELLED: the payment was cancelled by the shopper before completion, or the shopper returned to the merchant's site before completing the transaction.
# PENDING: it is not possible to obtain the final status of the payment.
# This can happen if the systems providing final status information for the payment are unavailable, or if the shopper needs to take further action to complete the payment.
# ERROR: an error occurred during the payment processing.

  end

  private

  def adyen_url
    Adyen::Form.redirect_url(
      :shopper_locale => 'zh_CN',
      :country_code => 'CN',
      :currency_code => 'CNY',
      :ship_before_date => Date.today,
      :session_validity => (Time.now.utc + 1.hour),
      :merchant_reference => REFERENCE,
      :merchant_account => ENV['adyen_merchant'],
      :skin_code => ENV['adyen_skin'],
      :shared_secret => ENV['adyen_shared_secret'],
      :payment_amount => AMOUNT, # cents
      :res_URL => callback_adyen_url
    )
  end

end
