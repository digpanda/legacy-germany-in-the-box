/**
 * CustomerCheckoutPaymentMethod class
 */
var CustomerCheckoutPaymentMethod = {

  /**
   * Initializer
   */
   init: function() {

    this.handleMethodSelection();
    this.handleSpecialInstructions();
    var CustomerCartShow = require("javascripts/controllers/customer/cart/show");

  },

  handleSpecialInstructions: function() {

    var Order = require("javascripts/models/order");

    $('#special_instructions').on('keyup', function(e) {

      let orderId = $(this).data('orderId');
      let params = {'special_instructions': $(this).val()};
      Order.update(orderId, params, function(res) {
        // nothing
      });

    });




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
