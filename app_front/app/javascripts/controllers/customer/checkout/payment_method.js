/**
 * CustomerCheckoutPaymentMethod class
 */
var CustomerCheckoutPaymentMethod = {

  /**
   * Initializer
   */
   init: function() {

    this.handleMethodSelection();
    var CustomerCartShow = require("javascripts/controllers/customer/cart/show");

  },

  /**
   * Will process after someone click to go through the payment gateway (blank page)
   */
   handleMethodSelection: function() {

     $('#payment_method_area').find('a').click(function(e) {

       $('#payment_method_area').hide();
       $('#after_payment_method_area').removeClass('+hidden');

     });
  },

}

module.exports = CustomerCheckoutPaymentMethod;
