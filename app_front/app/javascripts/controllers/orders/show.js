/**
 * OrdersShow class
 */
var OrdersShow = {

  /**
   * Initializer
   */
  init: function() {

    this.multiSelectSystem();

  },

  multiSelectSystem: function() {

    $('select.sku-variants-options').multiselect({
      enableCaseInsensitiveFiltering: true,
      maxHeight: 400,
    }).multiselect('disable');

  },
  
}

module.exports = OrdersShow;