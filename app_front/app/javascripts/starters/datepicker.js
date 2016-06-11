/**
 * Datepicker Class
 */
var Datepicker = {

    /**
     * Initializer
     */
    init: function() {
      var showDatepicker = $('#js-show-datepicker').data();
      var lang = showDatepicker.language ? showDatepicker.language : 'en'
      $('.date-picker').datepicker({ language: lang, autoclose: true, todayHighlight: true })
    },

}

module.exports = Datepicker;


