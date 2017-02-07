/**
 * TotalProducts Class
 */
var TotalProducts = {

    /**
     * Initializer
     */
    init: function() {

      this.refreshTotalProducts();

    },

    refreshTotalProducts: function() {

      var refreshTotalProducts = require('../services/refresh_total_products');
      refreshTotalProducts.resolveHiding($('.js-total-products').html());
      //refreshTotalProducts.perform();
      // <-- NOTE : this will make a condition race
      // we found no solution but to just show manually and render from server side to avoid it.

    },
}

module.exports = TotalProducts;
