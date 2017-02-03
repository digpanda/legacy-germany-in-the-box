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
      refreshTotalProducts.perform();

    },
}

module.exports = TotalProducts;
