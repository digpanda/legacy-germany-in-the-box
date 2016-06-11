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
        let language = showDatepicker.language ? showDatepicker.language : 'en'

        //$.fn.datepicker.defaults.format = "yyyy-mm-dd";

        $('input.customized-datepicker').datepicker({

          language: language,
          autoclose: true,
          todayHighlight: true,
          format: 'yyyy-mm-dd',

        });


      }

    },

}

module.exports = Datepicker;


