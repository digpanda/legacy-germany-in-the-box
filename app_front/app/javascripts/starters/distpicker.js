/**
 * Distpicker Class
 */
var Distpicker = {

    /**
     * Initializer
     */
    init: function() {

      if ($('#distpicker').length > 0) {
        $("#distpicker").distpicker();
      }

    },

}

module.exports = Distpicker;
