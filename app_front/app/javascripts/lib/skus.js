/**
 * Skus Class
 */
var Skus = {

  setup: function() {

    this.handleMultiSelect();
    this.handleForm();

  },

  /**
   * We turn the multi-select of the sku dashboard management into a readable checkbox select
   * @return {void}
   */
  handleMultiSelect: function() {

    var Translation = require('javascripts/lib/translation');

    $('select.sku-variants-options').multiselect({
      nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
      nSelectedText: Translation.find('n_selected_text', 'multiselect'),
      numberDisplayed: 3,
      maxHeight: 400,
      onChange: function(option, checked) {
        let v = $('.sku-variants-options')
        if ( v.val() ) {
          v.next().removeClass('invalidBorderClass')
        } else {
          v.next().addClass('invalidBorderClass')
        }
      }
    });

  },

  /**
   * This seems to handle the images warning on the skus form for shopkeeper and admin
   * NOTE : i didn't refactor this, it should be made cleaner and check the use.
   */
  handleForm: function() {

    $('#edit_product_detail_form_btn').click( function() {
      let v = $('select.sku-variants-options');

      if ( v.val() == null ) {
        v.next().addClass('invalidBorderClass');
        return false;
      }

      if ( $('img.img-responsive[src=""]').length >= 4) {
        $('.fileUpload:first').addClass('invalidBorderClass');
        return false;
      }

      $('input.img-file-upload').click( function() {
        if ( $('img.img-responsive[src=""]').length > 0) {
          $('.fileUpload').removeClass('invalidBorderClass');
        }
      });

      return true;
    });

  },


}

module.exports = Skus;
