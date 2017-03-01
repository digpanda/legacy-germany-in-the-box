# Get notifications from Alipay when a transaction has been done
class Api::Webhook::Alipay::CustomersController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    # List of parameters received on the notification
    # https://doc.open.alipay.com/doc2/detail.htm?treeId=140&articleId=104630&docType=1
    # Importan stuff i think:
    # trade_no: Alipay trade no., out_trade_no: should be our 'order.id',
    # trade_status: should be like 'TRADE_SUCCESS' The list of the status are on the same page below the first table.
  end
end
