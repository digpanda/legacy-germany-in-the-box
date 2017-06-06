var RefreshTotalProducts = require('javascripts/services/refresh_total_products')
var Messages = require("javascripts/lib/messages");

/**
 * Cart class
 */
var Cart = {

  clickChain: 0, // init click chain system
  chainTiming: 500, // in ms

  /**
   * Initializer
   */
  init: function() {

    this.orderItemHandleQuantity();
    this.removeOrderItem();
    this.removePackageSet();

  },

  getItemData: function(el) {
    return {
      orderId: $(el).data('orderId'),
      orderItemId: $(el).data('orderItemId'),
      orderShopId: $(el).data('orderShopId'),
      originQuantity: parseInt($('#order-item-quantity-'+$(el).data('orderItemId')).html()),
      originTotal: $('#order-item-total-'+$(el).data('orderItemId')).attr('data-origin')
    }
  },

  getSelectors: function(itemData) {
    return {
      item: $('#order-item-' + itemData.orderItemId),
      order: $('#order-' + itemData.orderId)
    }
  },

  removeItem: function(e) {
    e.preventDefault();

    var OrderItem = require("javascripts/models/order_item");
    var itemData = Cart.getItemData(this);

    OrderItem.removeProduct(itemData.orderItemId, function(res) {

      let selectors = Cart.getSelectors(itemData);

      if (res.success === true) {

        selectors.item.remove();

        // If the order itself is empty
        // We remove it as well
        if (res.order_empty == true){
          selectors.order.remove();
        }

        RefreshTotalProducts.perform();
        Cart.resetTotalDisplay(itemData.orderShopId, res);

      } else {

        Messages.makeError(res.error)

      }
    });
  },

  increaseQuantity: function(e) {
    e.preventDefault();
    let itemData = Cart.getItemData(this);
    let currentQuantity = itemData.originQuantity + 1;
    Cart.clickChain++;
    Cart.orderItemSetQuantity(itemData, currentQuantity);
  },

  decreaseQuantity: function(e) {
    e.preventDefault();
    let itemData = Cart.getItemData(this);
    let currentQuantity = itemData.originQuantity;
    if (itemData.originQuantity > 1) {
      currentQuantity--;
    }
    if (itemData.originQuantity != currentQuantity) {
      Cart.clickChain++;
      Cart.orderItemSetQuantity(itemData, currentQuantity);
    }
  },

  orderItemHandleQuantity: function() {

    $('.js-set-quantity-minus').on('click', Cart.decreaseQuantity);
    $('.js-set-quantity-plus').on('click', Cart.increaseQuantity);


    $('.js-set-package-quantity-minus').click(function(e) {

      e.preventDefault();
      Cart.clickChain++;

      let packageSetId = $(this).data('package-set-id');
      let currentQuantity = $('#package-quantity-'+packageSetId).html();
      let currentTotal = $('#package-total-'+packageSetId).attr('data-origin');
      let orderShopId = $(this).data('order-shop-id');
      let originQuantity = currentQuantity;
      let originTotal = currentTotal;

      if (currentQuantity > 1) {
          currentQuantity--;
      }

      if (originQuantity != currentQuantity) {
        Cart.clickChain++;
        Cart.orderItemSetQuantity(orderShopId, orderItemId, originQuantity, originTotal, currentQuantity);
      }

    });

    $('.js-set-package-quantity-plus').click(function(e) {

      e.preventDefault();
      Cart.clickChain++;

      let packageSetId = $(this).data('package-set-id');
      let currentQuantity = $('#package-quantity-'+packageSetId).html();
      let currentTotal = $('#package-total-'+packageSetId).attr('data-origin');
      let orderShopId = $(this).data('order-shop-id');
      let originQuantity = currentQuantity;
      let originTotal = currentTotal;

      currentQuantity++;
      Cart.packageSetSetQuantity(packageSetId, originQuantity, originTotal, currentQuantity, orderShopId);

    });

  },

  setItemLoading: function(itemData, currentQuantity) {
    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-'+itemData.orderItemId).html(currentQuantity);
    $('#order-item-total-'+itemData.orderItemId).html('-');
  },

  orderItemSetQuantity: function(itemData, currentQuantity) {

    Cart.setItemLoading(itemData, currentQuantity);
    var currentClickChain = Cart.clickChain;

    setTimeout(function() {
      // We basically prevent multiple click by considering only the last click as effective
      // It won't call the API if we clicked more than once on the + / - within the second
      if (currentClickChain == Cart.clickChain) {
        Cart.processQuantity(itemData, currentQuantity);
      }

    }, Cart.chainTiming);

  },

  packageSetSetQuantity: function(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

    // We first setup a temporary number before the AJAX callback
    $('#package-quantity-'+packageSetId).html(packageSetQuantity);
    $('#package-total-'+packageSetId).html('-');

    var currentClickChain = Cart.clickChain;

    setTimeout(function()                                                                                   {

        // We basically prevent multiple click by considering only the last click as effective
        // It won't call the API if we clicked more than once on the + / - within the second
        if (currentClickChain == Cart.clickChain)                                                           {
          Cart.processPackageSetQuantity(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId);
        }

      }, Cart.chainTiming);

    },

    removeOrderItem: function () {

        $('.delete-order-item').on('click', Cart.removeItem);

    },

    removePackageSet: function () {

        $('.delete-package-set').on('click', function (e) {

            e.preventDefault();

            // CartModel named this way because of collision because not well abstracted
            // we should keep refactor this shit.
            var CartModel = require("javascripts/models/cart");
            var orderId = $(this).data('order-id');
            var packageSetId = $(this).data('package-set-id');
            var orderShopId = $(this).data('order-shop-id');

            CartModel.removePackageSet(packageSetId, orderId, function(res) {


                if (res.success === true) {

                    $('#package-set-' + packageSetId).remove();

                    if (res.order_empty == true){
                        $('#order-' + orderId).remove();
                    } else {
                      Cart.resetTotalDisplay(orderShopId, res);
                    }

                } else {

                  console.log('error yo');

                    Messages.makeError(res.error)

                }
            });

        })

    },

  processQuantity: function(itemData, currentQuantity) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(itemData.orderItemId, currentQuantity, function(res) {



      if (res.success === false) {

        Cart.rollbackQuantity(itemData.originQuantity, itemData.originTotal, itemData.orderItemId, res);
        Messages.makeError(res.error);

      } else {

        // We first refresh the value in the HTML
        Cart.resetHeaderCartQuantity();
        Cart.resetDisplay(currentQuantity, itemData.orderItemId, itemData.orderShopId, res);

        var refreshTotalProducts = require('javascripts/services/refresh_total_products');
        refreshTotalProducts.perform();

      }

    });

  },

  processPackageSetQuantity: function(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setPackageSetQuantity(packageSetId, packageSetQuantity, function(res) {



        if (res.success === false) {

            Cart.rollbackPackageSetQuantity(originQuantity, originTotal, packageSetId, res);
            Messages.makeError(res.error);

        } else {

            // We first refresh the value in the HTML
            Cart.resetPackageDisplay(packageSetQuantity, packageSetId, orderShopId, res);

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

    Cart.resetTotalDisplay(orderShopId, res);

  },

  resetPackageDisplay: function(packageSetQuantity, packageSetId, orderShopId, res) {

      // Quantity changes
      $('#package-quantity-'+packageSetId).val(packageSetQuantity);
      $('#package-total-'+packageSetId).html(res.data.package_set.total_price);
      $('#package-total-'+packageSetId).attr('data-origin', res.data.package_set.total_price);

      Cart.resetTotalDisplay(orderShopId, res);

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

module.exports = Cart;
