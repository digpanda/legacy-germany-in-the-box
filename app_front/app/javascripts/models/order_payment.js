/**
 * OrderPayment Class
 */
var OrderPayment = {

  /**
   * Get the ProductSku details
   */
  show: function(orderPaymentId, callback) {

      $.ajax({

        method: "GET",
        url: '/api/customer/order_payments/' + orderPaymentId,
        data: {}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        if (typeof err == "undefined") {
          return;
        }

        callback({success: false, error: err.responseJSON.error});

      });

  },

};

module.exports = OrderPayment;
