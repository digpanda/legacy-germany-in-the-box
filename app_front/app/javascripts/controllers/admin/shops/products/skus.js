/**
 * ProductsSkus Class
 */
var ProductsSkus = {

  /**
   * Initializer
   */
  init: function() {

    /**
     * Since the system is cloned on the admin we try
     * to limit the code duplication by abstracting into a library
     */
    let Skus = require("javascripts/lib/skus");
    Skus.setup();

  },

}

module.exports = ProductsSkus;
