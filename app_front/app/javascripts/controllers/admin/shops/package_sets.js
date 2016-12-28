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

    $(document).ready(function() {
      $('select[name*="[product_id]"]').each(function(el) {
        PackageSets.refreshSku(this);
      })
    })

    $('select[name*="[product_id]"]').on('change', function(el) {
      PackageSets.refreshSku(this);
    });

  },

  refreshSku: function(self) {

    let productSelector = $(self);
    let ProductSku = require("javascripts/models/product_sku");
    let productId = productSelector.val();

    if (_.isEmpty(productId)) {
      return false;
    }

    ProductSku.all(productId, function(res) {

      if (res.success == true) {

        let skuSelector = productSelector.parent().parent().find('select[name*="[sku_id]"]');
        let possibleSkuId = productSelector.parent().parent().find('.js-sku-id');

        skuSelector.html('<option value="">-</option>');

        res.skus.forEach(function(sku) {

          skuSelector.append("<option value=\""+sku.id+"\">"+sku.option_names+"</option>");

          // If we are editing we should setup the pre-selected sku id
          let nearSkuId = possibleSkuId.data().skuId
          console.log(skuId);
          skuSelector.val(nearSkuId);


        });

      }

    });

  },

}

module.exports = PackageSets;
