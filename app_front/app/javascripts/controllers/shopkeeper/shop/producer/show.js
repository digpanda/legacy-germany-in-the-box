
/**
 * ShopsEditProducer Class
 */
var ShopsEditProducer = {

  /**
   * Initializer
   */
  init: function() {

    $(function() {
      $('.edit_producer_submit').click( function() {
        $('input.dynamical-required').each(
          function () {
            if ( $(this).val().length == 0 ) {
              $(this).addClass('invalidBorderClass');
            } else {
              $(this).removeClass('invalidBorderClass');
            }
          }
        );

        if ( $('.invalidBorderClass').length > 0 ) {
          return false;
        }
      });
    });

  },

}

module.exports = ShopsEditProducer;
