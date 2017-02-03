/**
 * RefreshTotalProducts Class
 */
var RefreshTotalProducts = {

  /**
   * Refresh it
   */
  perform: function() {

    console.log('jkljlk');
    var Cart = require('javascripts/models/cart');
    Cart.total(function(res) {
      $("#total-products").html(res.datas)
      RefreshTotalProducts.resolveHiding(res);
    });

  },

  resolveHiding: function(res) {
    if (res.datas > 0) {
      $('#total-products').removeClass('+hidden');
    } else {
      $('#total-products').addClass('+hidden');
    }
  }

}

module.exports = RefreshTotalProducts;
