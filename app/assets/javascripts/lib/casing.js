/**
 * Casing System
 * by Laurent Schaffner
 */
var Casing = (function($) {

  return {

    /**
     * Initializer
     */
    init: function() {

    },

    /**
     * CamelCase to underscored case
     */
    underscoreCase: function(string) {
     return string.replace(/(?:^|\.?)([A-Z])/g, function (x,y){return "_" + y.toLowerCase()}).replace(/^_/, "")
    },

    /**
     * Undescored to CamelCase
     */
    camelCase: function(string) {
      return string.replace(/(\-[a-z])/g, function($1){return $1.toUpperCase().replace('-','');});
    },

    /**
     * Convert an object to underscore case
     */
    objectToUnderscoreCase: function(obj) {

      var parsed = {};
      for (var key in obj) {

        new_key = this.underscoreCase(key);
        parsed[new_key] = obj[key];

      }

      return parsed

    },

  };

})(jQuery);

/**
 * jQuery scope and such
 */
(function ($) {

  $(document).ready(function() {

    Casing.init($);

  });

})(jQuery, Casing);