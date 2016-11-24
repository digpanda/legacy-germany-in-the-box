/**
* InputValidation Class
*/
var InputValidation = {

  /**
  * Initializer
  */
  init: function() {

    this.restrictToChinese();

  },

  /**
   * USE : just add data-error to an input to have the custom error show up
   */
  restrictToChinese: function() {

    $("input").on('invalid', function (e) {
      if (typeof $(this).data('error') != "undefined") {
        this.setCustomValidity($(this).data('error'));
      }
    });

    $("input").on('keyup', function(e) {
      this.setCustomValidity("");
    });

  },


}

module.exports = InputValidation;
