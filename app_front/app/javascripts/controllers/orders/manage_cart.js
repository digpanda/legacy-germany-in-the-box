/**
 * ManageCart class
 */
var ManageCart = {

  /**
   * Initializer
   */
  init: function() {

    this.multiSelectSystem();
    this.orderItemHandleQuantity();

  },

  multiSelectSystem: function() {

    $('select.sku-variants-options').multiselect({
      enableCaseInsensitiveFiltering: true,
      maxHeight: 400,
    }).multiselect('disable');

  },

  orderItemHandleQuantity: function() {

    $('.js-set-quantity-minus').click(function() {

      let orderItemId = $(this).data('orderItemId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();

      if (currentQuantity > 0) {
        currentQuantity--;
        ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);
      }

    });

    $('.js-set-quantity-plus').click(function() {
      
      let orderItemId = $(this).data('orderItemId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();

      currentQuantity++;
      ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);

    });

  },

  orderItemSetQuantity: function(orderItemId, orderItemQuantity) {

    var OrderItem = require("javascripts/models/order_item");

    OrderItem.setQuantity(orderItemId, orderItemQuantity, function(res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        Messages.makeError(res.error);

      } else {

        /**
         * Scheme
         * amount_in_carts integer
         * duty_cost_with_currency string
         * shipping_cost_with_currency string
         * total_with_currency string
         */
        
        // We first refresh the value in the HTML
        $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);
        $('#total-products').html(res.data.amount_in_carts);
        $('#order-subtotal').html(res.data.total_price_with_currency);
        $('#order-duty-cost').html(res.data.duty_cost_with_currency);
        $('#order-shipping-cost').html(res.data.shipping_cost_with_currency);
        $('#order-total-price-in-yuan').html(res.data.total_with_currency);

      }

    });

  },



/* SAME HERE
  // Should be in a lib
  setRedirectLocation: function(location) {

    $.ajax({
      method: "PATCH",
      url: "api/set_redirect_location",
      data: {"location": location}


    }).done(function(res) {

      // callback {"status": "ok"}

    });

  },
*/

}

module.exports = ManageCart;