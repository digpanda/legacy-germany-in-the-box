/**
 * CustomerCartShow class
 */
var CustomerCartShow = {

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
        CustomerCartShow.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, currentQuantity);
      }

    });

    $('.js-set-quantity-plus').click(function(e) {

      e.preventDefault();

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();
      let originQuantity = currentQuantity;

      currentQuantity++;
      CustomerCartShow.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, currentQuantity);

    });

  },

  orderItemSetQuantity: function(orderShopId, orderItemId, originQuantity, orderItemQuantity) {

    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(orderItemId, orderItemQuantity, function(res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        // We try to get back the correct value from AJAX if we can
        // To avoid the system to show a wrong quantity on the display
        if (typeof res.original_quantity != "undefined") {
          originQuantity = res.original_quantity;
        }

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
        //$('#total-products-'+orderShopId).html(res.data.amount_in_carts);

        // Quantity changes
        $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);

        // Total changes
        $('#order-total-price-'+orderShopId).html(res.data.total_price);
        $('#order-tax-and-shipping-cost-'+orderShopId).html(res.data.tax_and_shipping_cost);
        $('#order-end-price-'+orderShopId).html(res.data.end_price);

        // Discount management
        if (typeof res.data.total_price_with_discount != "undefined") {
          $('#order-total-price-with-extra-costs-'+orderShopId).html(res.data.total_price_with_extra_costs);
          $('#order-total-price-with-discount-'+orderShopId).html(res.data.total_price_with_discount);
          $('#order-discount-display-'+orderShopId).html(res.data.discount_display);
        }

      }

    });

  },

}

module.exports = CustomerCartShow;
