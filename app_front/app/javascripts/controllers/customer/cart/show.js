var RefreshTotalProducts = require('javascripts/services/refresh_total_products')

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

    this.orderItemHandleQuantity();
    this.removeOrderItem();
    this.removePackageSet();

  },

  orderItemHandleQuantity: function() {

    $('.js-set-quantity-minus').click(function(e) {

      e.preventDefault();
      CustomerCartShow.click_chain++;

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).html();
      let currentTotal = $('#order-item-total-'+orderItemId).attr('data-origin');

      let originQuantity = currentQuantity;
      let originTotal = currentTotal;

      if (currentQuantity > 1) {
        currentQuantity--;
      }

      CustomerCartShow.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, originTotal, currentQuantity);

    });

    $('.js-set-quantity-plus').click(function(e) {

      e.preventDefault();
      CustomerCartShow.click_chain++;

      let orderItemId = $(this).data('orderItemId');
      let orderShopId = $(this).data('orderShopId');
      let currentQuantity = $('#order-item-quantity-'+orderItemId).html();
      let currentTotal = $('#order-item-total-'+orderItemId).attr('data-origin');
      let originQuantity = currentQuantity;
      let originTotal = currentTotal

      currentQuantity++;
      CustomerCartShow.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, originTotal, currentQuantity);

    });

    $('.js-set-package-quantity-minus').click(function(e) {

      e.preventDefault();
      CustomerCartShow.click_chain++;

      let packageSetId = $(this).data('package-set-id');
      let currentQuantity = $('#package-quantity-'+packageSetId).html();
      let currentTotal = $('#package-total-'+packageSetId).attr('data-origin');
      let orderShopId = $(this).data('order-shop-id');
      let originQuantity = currentQuantity;
      let originTotal = currentTotal;

      if (currentQuantity > 1) {
          currentQuantity--;
      }

      CustomerCartShow.packageSetSetQuantity(packageSetId, originQuantity, originTotal, currentQuantity, orderShopId);

    });

    $('.js-set-package-quantity-plus').click(function(e) {

      e.preventDefault();
      CustomerCartShow.click_chain++;

      let packageSetId = $(this).data('package-set-id');
      let currentQuantity = $('#package-quantity-'+packageSetId).html();
      let currentTotal = $('#package-total-'+packageSetId).attr('data-origin');
      let orderShopId = $(this).data('order-shop-id');
      let originQuantity = currentQuantity;
      let originTotal = currentTotal;

      currentQuantity++;
      CustomerCartShow.packageSetSetQuantity(packageSetId, originQuantity, originTotal, currentQuantity, orderShopId);

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

  orderItemSetQuantity: function(orderShopId, orderItemId, originQuantity, originTotal, orderItemQuantity) {

    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-'+orderItemId).html(orderItemQuantity);
    $('#order-item-total-'+orderItemId).html('-')
    CustomerCartShow.loading();

    var current_click_chain = CustomerCartShow.click_chain;

    setTimeout(function() {

      // We basically prevent multiple click by considering only the last click as effective
      // It won't call the API if we clicked more than once on the + / - within the second
      if (current_click_chain == CustomerCartShow.click_chain) {
        CustomerCartShow.processQuantity(orderShopId, orderItemId, originQuantity, originTotal, orderItemQuantity);
      }

    }, CustomerCartShow.chain_timing);

  },

    packageSetSetQuantity: function(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

        // We first setup a temporary number before the AJAX callback
        $('#package-quantity-'+packageSetId).html(packageSetQuantity);
        $('#package-total-'+packageSetId).html('-');

        CustomerCartShow.loading();

        var current_click_chain = CustomerCartShow.click_chain;

        setTimeout(function() {

            // We basically prevent multiple click by considering only the last click as effective
            // It won't call the API if we clicked more than once on the + / - within the second
            if (current_click_chain == CustomerCartShow.click_chain) {
                CustomerCartShow.processPackageSetQuantity(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId);
            }

        }, CustomerCartShow.chain_timing);

    },

    removeOrderItem: function () {

        $('.delete-order-item').on('click', function (e) {

            e.preventDefault();

            var OrderItem = require("javascripts/models/order_item");
            var orderItemId = $(this).data('id');
            var orderId = $(this).data('order-id');
            var orderShopId = $(this).data('order-shop-id');

            OrderItem.removeProduct(orderItemId, function(res) {

                var Messages = require("javascripts/lib/messages");

                if (res.success === true) {

                    $('#order-item-' + orderItemId).remove();

                    if (res.order_empty == true){
                        $('#order-' + orderId).remove();
                    } else {
                        if (res.data.order_empty == true){
                            $('#order-' + orderId).remove();
                        }
                        // Total changes
                        $('#order-total-price-with-taxes-'+orderShopId).html(res.data.total_price_with_taxes);
                        $('#order-shipping-cost-'+orderShopId).html(res.data.shipping_cost);
                        $('#order-end-price-'+orderShopId).html(res.data.end_price);

                        // Discount management
                        if (typeof res.data.total_price_with_discount != "undefined") {
                            $('#order-total-price-with-extra-costs-'+orderShopId).html(res.data.total_price_with_extra_costs);
                            $('#order-total-price-with-discount-'+orderShopId).html(res.data.total_price_with_discount);
                            $('#order-discount-display-'+orderShopId).html(res.data.discount_display);
                        }
                    }

                    RefreshTotalProducts.perform();

                } else {

                    Messages.makeError(res.error)

                }
            });

        })

    },

    removePackageSet: function () {

        $('.delete-package-set').on('click', function (e) {

            e.preventDefault();

            var Cart = require("javascripts/models/cart");
            var orderId = $(this).data('order-id');
            var packageSetId = $(this).data('package-set-id');
            var orderShopId = $(this).data('order-shop-id');

            Cart.removePackageSet(packageSetId, orderId, function(res) {

                var Messages = require("javascripts/lib/messages");

                if (res.success === true) {

                    $('#package-set-' + packageSetId).remove();

                    if (res.order_empty == true){
                        $('#order-' + orderId).remove();
                    } else {
                        if (res.data.order_empty == true){
                            $('#order-' + orderId).remove();
                        }
                        // Total changes
                        $('#order-total-price-with-taxes-'+orderShopId).html(res.data.total_price_with_taxes);
                        $('#order-shipping-cost-'+orderShopId).html(res.data.shipping_cost);
                        $('#order-end-price-'+orderShopId).html(res.data.end_price);

                        // Discount management
                        if (typeof res.data.total_price_with_discount != "undefined") {
                            $('#order-total-price-with-extra-costs-'+orderShopId).html(res.data.total_price_with_extra_costs);
                            $('#order-total-price-with-discount-'+orderShopId).html(res.data.total_price_with_discount);
                            $('#order-discount-display-'+orderShopId).html(res.data.discount_display);
                        }
                    }

                    RefreshTotalProducts.perform();

                } else {

                    Messages.makeError(res.error)

                }
            });

        })

    },

  processQuantity: function(orderShopId, orderItemId, originQuantity, originTotal, orderItemQuantity) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(orderItemId, orderItemQuantity, function(res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        console.log('problem in the processing');
        CustomerCartShow.rollbackQuantity(originQuantity, originTotal, orderItemId, res);
        CustomerCartShow.loaded();
        Messages.makeError(res.error);

      } else {

        // We first refresh the value in the HTML
        CustomerCartShow.resetHeaderCartQuantity();
        CustomerCartShow.resetDisplay(orderItemQuantity, orderItemId, orderShopId, res);
        CustomerCartShow.loaded();

        var refreshTotalProducts = require('javascripts/services/refresh_total_products');
        refreshTotalProducts.perform();

      }

    });

  },

  processPackageSetQuantity: function(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setPackageSetQuantity(packageSetId, packageSetQuantity, function(res) {

        var Messages = require("javascripts/lib/messages");

        if (res.success === false) {

            CustomerCartShow.rollbackPackageSetQuantity(originQuantity, originTotal, packageSetId, res);
            CustomerCartShow.loaded();
            Messages.makeError(res.error);

        } else {

            // We first refresh the value in the HTML
            CustomerCartShow.resetPackageDisplay(packageSetQuantity, packageSetId, orderShopId, res);
            CustomerCartShow.loaded();

            var refreshTotalProducts = require('javascripts/services/refresh_total_products');
            refreshTotalProducts.perform();

        }

    });

  },

  resetHeaderCartQuantity: function() {

    /**
     * NOTE : This system was cancelled because we don't show
     * the number of product within the cart
     * - Laurent, 23/01/2017
     */
    // var total = 0;
    //
    // $('[id^="order-item-quantity-"]').each(function(e) {
    //   total += parseInt($(this).val());
    //   $('#total-products').html(total);
    // })

  },

  rollbackQuantity: function(originQuantity, originTotal, orderItemId, res) {

    // TODO : possible improvement
    // instead of rolling back completely we could make a system
    // to try again with different quantity

    // We try to get back the correct value from AJAX if we can
    // To avoid the system to show a wrong quantity on the display
    if ((typeof res.original_quantity != "undefined") && (typeof res.original_total != "undefined")) {
      originQuantity = res.original_quantity;
      originTotal = res.original_total;
    }

    // We rollback the quantity
    $('#order-item-quantity-'+orderItemId).html(originQuantity);
    $('#order-item-total-'+orderItemId).html(originTotal);

  },

  rollbackPackageSetQuantity: function(originQuantity, originTotal, packageSetId, res) {

    if ((typeof res.original_quantity != "undefined") && (typeof res.original_total != "undefined")) {
        originQuantity = res.original_quantity;
        originTotal = res.original_total;
    }

    // We rollback the quantity
    $('#package-quantity-'+packageSetId).val(originQuantity);
    $('#package-total-'+packageSetId).val(originTotal);

  },

  resetDisplay: function(orderItemQuantity, orderItemId, orderShopId, res) {

    // Quantity changes
    $('#order-item-quantity-'+orderItemId).html(orderItemQuantity);
    $('#order-item-total-'+orderItemId).html(res.data.order_item.total_price_with_taxes);
    $('#order-item-total-'+orderItemId).attr('data-origin', res.data.order_item.total_price_with_taxes);

    CustomerCartShow.resetTotalDisplay(orderShopId, res);

  },

  resetPackageDisplay: function(packageSetQuantity, packageSetId, orderShopId, res) {

      // Quantity changes
      $('#package-quantity-'+packageSetId).val(packageSetQuantity);
      $('#package-total-'+packageSetId).html(res.data.package_set.total_price);
      $('#package-total-'+packageSetId).attr('data-origin', res.data.package_set.total_price);

      CustomerCartShow.resetTotalDisplay(orderShopId, res);

  },

  resetTotalDisplay: function(orderShopId, res) {

      // Total changes
      $('#order-total-price-with-taxes-'+orderShopId).html(res.data.total_price_with_taxes);
      $('#order-shipping-cost-'+orderShopId).html(res.data.shipping_cost);
      $('#order-end-price-'+orderShopId).html(res.data.end_price);

      // Discount management
      if (typeof res.data.total_price_with_discount != "undefined") {
          $('#order-total-price-with-extra-costs-'+orderShopId).html(res.data.total_price_with_extra_costs);
          $('#order-total-price-with-discount-'+orderShopId).html(res.data.total_price_with_discount);
          $('#order-discount-display-'+orderShopId).html(res.data.discount_display);
      }

  }

}

module.exports = CustomerCartShow;
