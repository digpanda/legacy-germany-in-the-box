/**
 * CustomerGatewayCreate class
 */
var CustomerGatewayCreate = {

  /**
   * Initializer
   */
   init: function() {

    this.postBankDetails();

    // We will check the order payment every once in a while
    setInterval(this.orderPaymentLiveRefresh, 3000);

  },

  /**
   * We refresh the page according to the order payment status
   */
   orderPaymentLiveRefresh: function() {

     // If it's Wechatpay from Desktop and it needs auto refresh
     if ($("#order-payment-live-refresh").length > 0) {

       var OrderPayment = require("javascripts/models/order_payment");
       let orderPaymentId = $('#order-payment-live-refresh').data('order-payment-id');

       OrderPayment.show(orderPaymentId, function(res) {

         if (res.success === true) {

           // We can check the order payment status
           switch (res.order_payment.status) {
             case "scheduled":
              break;
             case "unverified":
              // Unverified means an action has been done but is awaiting approval; it's like a success.
              window.location.href = $("#order-payment-callback-url").data('success');
              break;
            case 'success':
              window.location.href = $("#order-payment-callback-url").data('success');
              break;
            case "failed":
              window.location.href = $("#order-payment-callback-url").data("fail")
              break;
            default:
              break;
           }

         } else {

           Messages.makeError(res.error);

         }
       });


     }

   },

  /**
   * Post bank details to the `form_url`
   */
   postBankDetails: function() {

    // If it's Wirecard
    if ($("#bank-details").length > 0) {

      var Casing = require("javascripts/lib/casing");
      var PostForm = require("javascripts/lib/post_form.js");

      let bankDetails = $("#bank-details")[0].dataset;
      let parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

      PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

    }

  },

}

module.exports = CustomerGatewayCreate;
