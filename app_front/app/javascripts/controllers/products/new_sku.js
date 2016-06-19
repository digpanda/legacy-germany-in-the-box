
/**
 * ProductNewSku Class
 */
var ProductNewSku = {

  /**
   * Initializer
   */
  init: function() {

    $('select.sku-variants-options').multiselect({
      nonSelectedText: ProductNewSku.data().translationNonSelectedText,
      nSelectedText: ProductNewSku.data().translationNSelectedText,
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
    return $('#js-new-sku').data()
  },

/* UNUSED IN THE CURRENT SYSTEM
  validatePdfFile: function(inputFile) {

    var maxExceededMessage = ProductNewSku.data().translationMaxExceedMessage;
    var extErrorMessage = ProductNewSku.data().translationExtErrorMessage;
    var allowedExtension = ["pdf"];

    var extName;
    var maxFileSize = 2097152;
    var sizeExceeded = false;
    var extError = false;

    $.each(inputFile.files, function() {
      if (this.size && maxFileSize && this.size > maxFileSize) {sizeExceeded=true;};
      extName = this.name.split('.').pop();
      if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
    });
    if (sizeExceeded) {
      window.alert(maxExceededMessage);
      $(inputFile).val('');
    };

    if (extError) {
      window.alert(extErrorMessage);
      $(inputFile).val('');
    };
  }
**/
}

module.exports = ProductNewSku;
