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
    // $.ajax({
    //   method: "GET",
    //   url: "/api/guest/cart/total",
    //   data: {}
    //
    // }).done(function(res) {
    //
    //   callback(res);
    //
    // }).error(function(err) {
    //
    //   callback({success: false, error: err.responseJSON.error});
    //
    // });

  },

}

module.exports = Cart;
