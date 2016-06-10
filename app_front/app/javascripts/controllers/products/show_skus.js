
/**
 * ProductsShowSkus Class
 */
var ProductsShowSkus = {

  /**
   * Initializer
   */
  init: function() {

    if ($('#js-show-skus').length > 0) {

      var showSkus = $('#js-show-skus').data();

      $('select.sku-variants-options').multiselect({
        nonSelectedText: showSkus.translationNonSelectedText,
        nSelectedText: showSkus.translationNSelectedText,
        numberDisplayed: 3,
        maxHeight: 400
      }).multiselect('disable');

    }

  },

}

module.exports = ProductsShowSkus;
