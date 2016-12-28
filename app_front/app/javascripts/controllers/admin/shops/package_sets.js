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

      $('select[name^="package_set[product_id]"]').on('change', function(el) {

        let ProductSku = require("javascripts/models/product_sku");
        let productSelector = $(this);
        let productId = productSelector.val();

        ProductSku.all(productId, function(res) {

          if (res.success == true) {

            let skuSelector = productSelector.next('select[name^="package_set[sku_id]"]');

            skuSelector.html('<option value="">-</option>');

            res.skus.forEach(function(sku) {

              skuSelector.append("<option value=\""+sku.id+"\">"+sku.option_names+"</option>")

            });

          }

        });

      });

    },
}

module.exports = PackageSets;
