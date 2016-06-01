/**
 * Casing Class
 */
var Casing = {

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

        let new_key = this.underscoreCase(key);
        parsed[new_key] = obj[key];

      }

      return parsed

    },
    
}

module.exports = Casing;