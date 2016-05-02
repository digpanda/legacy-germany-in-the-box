/**
 * Checkout class
 */
var Checkout = (function($) {

  return {

    /**
     * Initializer
     */
    init: function() {

      this.postBankDetails();

    },

    /**
     * Post bank details to the `form_url`
     */
    postBankDetails: function() {

      let bankDetails = $("#bank-details").data();
      let parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

      PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

    },

  };

})($);

/**
 * jQuery scope and such
 */
(function ($) {

  $(document).ready(function() {

    Checkout.init($);

  });

})(jQuery, Checkout);