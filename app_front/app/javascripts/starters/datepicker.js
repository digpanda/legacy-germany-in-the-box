/**
 * Datepicker Class
 */
var Datepicker = {

    /**
     * Initializer
     */
    init: function() {

      if ($('#js-show-datepicker').length > 0) {

        let showDatepicker = $('#js-show-datepicker').data();
        let language = showDatepicker.language ? showDatepicker.language : 'de';

        if (language == 'de') {
          require("javascripts/lib/foreign/datepicker-de.js");
        } else {
          require("javascripts/lib/foreign/datepicker-zh-CN.js");
        }

      $( "#datepicker" ).datepicker({
        changeMonth: true,
        changeYear: true,
        yearRange: '1945:'+(new Date).getFullYear(),
        dateFormat: "yy-mm-dd"    
      });
     
      }

    },

}

module.exports = Datepicker;


