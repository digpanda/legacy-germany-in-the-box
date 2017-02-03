/**
 * Cart Class
 */
var Cart = {

  /**
   * Get the total number of products within the cart
   */
  total: function(callback) {

    $.ajax({
      method: "GET",
      url: "/api/guest/cart/total",
      data: {}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      callback({success: false, error: err.responseJSON.error});

    });

  },

}

module.exports = Cart;
