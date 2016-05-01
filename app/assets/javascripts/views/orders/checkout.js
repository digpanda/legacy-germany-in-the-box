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
      let parsedBankDetails = this.objectToUnderscoreCase(bankDetails);
    
      PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

    },

    /**
     * CamelCase to underscored case
     */
    underscoreCase: function(string) {
     return string.replace(/(?:^|\.?)([A-Z])/g, function (x,y){return "_" + y.toLowerCase()}).replace(/^_/, "")
    },

    /**
     * Convert an object to underscore case
     */
    objectToUnderscoreCase: function(obj) {

      let parsed = {};
      for (var key in obj) {

        new_key = this.underscoreCase(key);
        parsed[new_key] = obj[key];

      }

      return parsed

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