/**
 * CustomerGatewayCreate class
 */
var CustomerGatewayCreate = {

  /**
   * Initializer
   */
   init: function() {

    this.postBankDetails();
    this.orderPaymentLiveRefresh();

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
           console.log(res);

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
