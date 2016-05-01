/**
 * Don't forget to add this file to the assets precompile in
 * config/initializers/assets.rb for Rails Assets Pipeline
 * - Laurent
 */

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
      
      this.postForm(parsedBankDetails, parsedBankDetails['form_url']);

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

    /**
     * Generate and create a form
     */
    postForm: function(params, path, target, method) {

      method = method || "POST";
      path = path || "";
      target = target || "";

      var form = document.createElement("form");
      form.setAttribute("method", method);
      form.setAttribute("action", path);
      form.setAttribute("target", target); 

      for (var key in params) {

        if (params.hasOwnProperty(key))  {

          var f = document.createElement("input");
          f.setAttribute("type", "hidden");
          f.setAttribute("name", key);
          f.setAttribute("value", params[key]);
          form.appendChild(f);

        }

      }

      // document.body.appendChild(form); <- JS way (body was emptied for unknown reason in the process)
      $('body').append(form); // <- jQuery way
      console.log ('yo');
      // form.submit();

    } 

  };

})($);

/**
 * jQuery scope and such
 */
(function ($) {

  Checkout.init($);

})(jQuery, Checkout);