/**
 * CustomerCartShow class
 */
var CustomerCartShow = {

  click_chain: 0, // init click chain system
  chain_timing: 500, // in ms

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
      CustomerCartShow.click_chain++;

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
      CustomerCartShow.click_chain++;

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).val();
      let originQuantity = currentQuantity;

      currentQuantity++;
      CustomerCartShow.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, currentQuantity);

    });

  },

  loaded: function() {

    $('.js-loader').hide();
    $('#cart-total').show();

  },

  loading: function() {

    $('.js-loader').show();
    $('#cart-total').hide();

  },

  orderItemSetQuantity: function(orderShopId, orderItemId, originQuantity, orderItemQuantity) {

    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);
    CustomerCartShow.loading();

    var current_click_chain = CustomerCartShow.click_chain;

    setTimeout(function() {

      // We basically prevent multiple click by considering only the last click as effective
      // It won't call the API if we clicked more than once on the + / - within the second
      if (current_click_chain == CustomerCartShow.click_chain) {
        CustomerCartShow.processQuantity(orderShopId, orderItemId, originQuantity, orderItemQuantity);
      }

    }, CustomerCartShow.chain_timing);

  },

  processQuantity: function(orderShopId, orderItemId, originQuantity, orderItemQuantity) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(orderItemId, orderItemQuantity, function(res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        CustomerCartShow.rollbackQuantity(originQuantity, res);
        Messages.makeError(res.error);

      } else {

        // We first refresh the value in the HTML
        CustomerCartShow.resetDisplay(orderItemQuantity, orderItemId, orderShopId, res.data);
        CustomerCartShow.loaded();

      }

    });

  },

  rollbackQuantity: function(originQuantity, res) {

    // We try to get back the correct value from AJAX if we can
    // To avoid the system to show a wrong quantity on the display
    if (typeof res.original_quantity != "undefined") {
      originQuantity = res.original_quantity;
    }

    // We rollback the quantity
    $('#order-item-quantity-'+orderItemId).val(originQuantity);

  },

  resetDisplay: function(orderItemQuantity, orderItemId, orderShopId, data) {

    // Quantity changes
    $('#order-item-quantity-'+orderItemId).val(orderItemQuantity);

    // Total changes
    $('#order-total-price-'+orderShopId).html(data.total_price);
    $('#order-tax-and-shipping-cost-'+orderShopId).html(data.tax_and_shipping_cost);
    $('#order-end-price-'+orderShopId).html(data.end_price);

    // Discount management
    if (typeof data.total_price_with_discount != "undefined") {
      $('#order-total-price-with-extra-costs-'+orderShopId).html(data.total_price_with_extra_costs);
      $('#order-total-price-with-discount-'+orderShopId).html(data.total_price_with_discount);
      $('#order-discount-display-'+orderShopId).html(data.discount_display);
    }

  },

}

module.exports = CustomerCartShow;
