/**
 * ProductsVariants Class
 */
var ProductsVariants = {

  /**
   * Initializer
   */
  init: function() {

    /**
     * Since the system is cloned on the admin we try
     * to limit the code duplication by abstracting into a library
     */
    let Variants = require("javascripts/lib/variants");
    Variants.setup();

  },

}

module.exports = ProductsVariants;
