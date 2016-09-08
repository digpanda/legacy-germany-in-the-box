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

    $('.js-set-quantity-minus').click(function(e) {

      e.preventDefault();

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();
      let originQuantity = currentQuantity;

      if (currentQuantity > 0) {
        currentQuantity--;
        ManageCart.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, currentQuantity);
      }

    });

    $('.js-set-quantity-plus').click(function(e) {

      e.preventDefault();

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();
      let originQuantity = currentQuantity;

      currentQuantity++;
      ManageCart.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, currentQuantity);

    });

  },

  orderItemSetQuantity: function(orderShopId, orderItemId, originQuantity, orderItemQuantity) {

    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(orderItemId, orderItemQuantity, function(res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        // We rollback the quantity
        $('#order-item-quantity-'+orderItemId).val(originQuantity);
        Messages.makeError(res.error);

      } else {

        /**
         * Scheme
         * amount_in_carts integer
         * duty_cost_with_currency string
         * shipping_cost_with_currency_yuan string
         * total_with_currency string
         */

        // We first refresh the value in the HTML
        $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);
        $('#total-products-'+orderShopId).html(res.data.amount_in_carts);
        $('#order-subtotal-'+orderShopId).html(res.data.total_price_with_currency_yuan);
        //$('#order-duty-cost-'+orderShopId).html(res.data.duty_cost_with_currency);
        //$('#order-shipping-cost-'+orderShopId).html(res.data.shipping_cost_with_currency_yuan);
        $('#order-duty-and-shipping-cost-'+orderShopId).html(res.data.duty_and_shipping_cost_with_currency_yuan);
        $('#order-total-sum-in-yuan-'+orderShopId).html(res.data.total_sum_in_yuan);

      }

    });

  },

}

module.exports = ManageCart;
