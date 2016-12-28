/**
 * PackageSets Class
 */
var PackageSets = {

    /**
     * Initializer
     */
    init: function() {

      this.handleSelect();

    },

    handleSelect: function() {

      $('.product_id[]').on('change', function(el) {

        let ProductSku = require("javascripts/models/product_sku");
        let productId = $(this).val();
        let productSelector = this;

        ProductSku.all(productId, function(res) {

          if (res.success == true) {

            res.skus.forEach(function(el) {

              $(productSelector).closest('.sku_id[]').html("YOYO");

            });

          }

        });

      });

    },
}

module.exports = PackageSets;
