/**
 * Cart Class
 */
var Cart = {

  /**
   * Get the total number of products within the cart
   */
  total: function(callback) {

    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/guest/cart/total",
      data: {}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({success: false, error: err.responseJSON.error});

    });

  },

  removePackageSet: function(packageSetId, orderId, callback) {

      $.ajax({
          method: "POST",
          url: "/api/guest/cart/destroy_package_set",
          data: {"package_set_id" : packageSetId, "order_id" : orderId}

      }).done(function(res) {

          callback(res);

      }).error(function(err) {

        if (typeof err == "undefined") {
          return;
        }

        callback({success: false, error: err.responseJSON.error});

      });

  }

};

module.exports = Cart;
