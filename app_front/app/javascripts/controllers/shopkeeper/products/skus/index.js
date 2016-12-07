var Translation = require('javascripts/lib/translation');

/**
 * ProductsShowSkus Class
 */
var ProductsShowSkus = {

  /**
   * Initializer
   */
  init: function() {

    if ($('select.sku-variants-options').length > 0) {

      $('select.sku-variants-options').multiselect({
        nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
        nSelectedText: Translation.find('n_selected_text', 'multiselect'),
        numberDisplayed: 3,
        maxHeight: 400
      }).multiselect('disable');

    }

  },

}

module.exports = ProductsShowSkus;
