/**
 * ProductEditSku Class
 */
var ProductEditSku = {

  /**
   * Initializer
   */
  init: function() { // WE SHOULD DEFINITELY REFACTOR THOSE 3 CLASSES (NEW, EDIT, CLONE) INTO ONE

    $('select.sku-variants-options').multiselect({
      nonSelectedText: ProductEditSku.data().translationNonSelectedText,
      nSelectedText: ProductEditSku.data().translationNSelectedText,
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

      return true;
    });

    $('input.img-file-upload').click( function() {
      if ( $('img.img-responsive[src=""]').length > 0) {
        $('.fileUpload').removeClass('invalidBorderClass');
      }
    });



  },

  data: function(data) {
    return $('#js-images-control').data()
  },

}

module.exports = ProductEditSku;
