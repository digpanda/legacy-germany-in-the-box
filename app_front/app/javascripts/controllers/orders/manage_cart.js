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

    $('#js-set-quantity-minus').click(function() {

      let currentQuantity = $('#js-set-quantity-value').val();
      let orderItemId = $('#js-set-quantity-value').data('orderItemId');

      if (currentQuantity > 0) {
        currentQuantity--;
        ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);
      }

    });

    $('#js-set-quantity-plus').click(function() {
      
      let currentQuantity = $('#js-set-quantity-value').val();
      let orderItemId = $('#js-set-quantity-value').data('orderItemId');

      currentQuantity++;
      ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);

    });

  },

  orderItemSetQuantity: function(orderItemId, quantity) {

    var OrderItem = require("javascripts/models/order_item");


    OrderItem.setQuantity(orderItemId, quantity, function(res) {

      console.log(res);

      if (res === false) {

      } else {

        // No problem

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