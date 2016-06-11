/**
 * Datepicker Class
 */
var Datepicker = {

    /**
     * Initializer
     */
    init: function() {

      if ( $('#js-show-datepicker').length > 0) {

        let showDatepicker = $('#js-show-datepicker').data();
        let lang = showDatepicker.language ? showDatepicker.language : 'en'
        $('.date-picker').datepicker({ language: lang, autoclose: true, todayHighlight: true })

      }

    },

}

module.exports = Datepicker;


