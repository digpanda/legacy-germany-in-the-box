
/**
 * ShopApplicationsNew Class
 */
var ShopApplicationsNew = {

  /**
   * Initializer
   */
  init: function() {

    if ($('#add_sales_channel_btn').length > 0) {
      
      $('#add_sales_channel_btn').click();

      $('#edit_app_submit_btn').click( function() {
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

    }

  },

}

module.exports = ShopApplicationsNew;