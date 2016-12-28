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

      $('select[name*="[product_id]"]').on('change', function(el) {

        let ProductSku = require("javascripts/models/product_sku");
        var productSelector = $(this);
        let productId = productSelector.val();

        ProductSku.all(productId, function(res) {

          if (res.success == true) {

            let skuSelector = productSelector.parent().find('select[name*="[sku_id]"]');

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
