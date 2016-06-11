/**
 * ImageControl Class
 */
var ImagesControl = {

    /**
     * Initializer
     */
    init: function() {

      this.validateImageFile();

    },

    validateImageFile: function() {

      console.log('loaded');

      $("input[class^=img-file-upload]").on('change', function() {

        var inputFile = this;

        var maxExceededMessage = ""; // #{I18n.t(:max_exceeded_message, scope: :image_upload)} to catch
        var extErrorMessage = ""; // #{I18n.t(:ext_error_message, scope: :image_upload)} to catch
        var allowedExtension = ["jpg", "JPG", "jpeg", "JPEG", "png", "PNG"];

        var extName;
        var maxFileSize = 1048576;
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

      });

    }

}

module.exports = ImagesControl;
