
/**
 * Checkout class
 */
var Checkout = (function($) {

  return {

    /**
     * Initializer
     */
    init: function() {

      this.post_bank_details();

    },

    /**
     * Post bank details to the `form_url`
     */
    post_bank_details: function() {

      let bank_details = $("#bank-details").data();
      let parsed_bank_details = this.object_to_underscore_case(bank_details);
      
      this.post_form(parsed_bank_details, parsed_bank_details['form_url']);

    },

    /**
     * CamelCase to underscored case
     */
    underscore_case: function(string) {
     return string.replace(/(?:^|\.?)([A-Z])/g, function (x,y){return "_" + y.toLowerCase()}).replace(/^_/, "")
    },

    /**
     * Convert an object to underscore case
     */
    object_to_underscore_case: function(obj) {

      let parsed = {};
      for (var key in obj) {

        new_key = this.underscore_case(key);
        parsed[new_key] = obj[key];

      }

      return parsed

    },

    /**
     * Generate and create a form
     */
    post_form: function(params, path, target, method) {

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

      document.body.appendChild(form);
      form.submit();

    } 

  };

})($);

/**
 * jQuery scope and such
 */
(function ($) {

  Checkout.init($);

})(jQuery, Checkout);