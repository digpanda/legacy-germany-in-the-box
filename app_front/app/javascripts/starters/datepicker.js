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

        //$("#datepicker").datepicker( $.datepicker.regional[ "fr" ] );
        //$.datepicker.regional[ "de" ]

        $('#datepicker').datepicker({

          //language: language,
          //autoclose: true,
          //todayHighlight: true,
          dateFormat: "yy-mm-dd"

        });

      }

    },

}

module.exports = Datepicker;


