
/**
 * ProductsShowSkus Class
 */
var ProductsShowSkus = {

  /**
   * Initializer
   */
  init: function() {

    if ($('#js-show-skus').length > 0) {

      $('select.sku-variants-options').multiselect({
        nonSelectedText: ProductsShowSkus.data().translationNonSelectedText,
        nSelectedText:ProductsShowSkus.data().translationNSelectedText,
        numberDisplayed: 3,
        maxHeight: 400
      }).multiselect('disable');

    }

  },

  data: function() {
     return $('#js-show-skus').data();
  },

}

module.exports = ProductsShowSkus;
