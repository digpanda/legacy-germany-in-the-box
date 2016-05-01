/**
 * Apply Wirecard Class
 */
var ApplyWirecard = (function($) {

  return {

    /**
     * Initializer
     */
    init: function() {

      this.postShopDetails();

    },

    /**
     * Post shop details to the `form_url`
     */
    postShopDetails: function() {

      let shopDetails = $("#shop-details").data();
      let parsedShopDetails = Casing.objectToUnderscoreCase(shopDetails);
    
      PostForm.send(parsedShopDetails, parsedShopDetails['form_url']);

    },

  };

})($);

/**
 * jQuery scope and such
 */
(function ($) {

  $(document).ready(function() {

    ApplyWirecard.init($);

  });

})(jQuery, ApplyWirecard);