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

    data: function(data) {
      return $('#js-shops-edit-setting').data()
    },

    validateImageFile: function() {

      $("input[class^=img-file-upload]").on('change', function() {

        var Messages = require("javascripts/lib/messages");
        var inputFile = this;

        var maxExceededMessage = ImagesControl.data().translationMaxExceededMessage;
        var extErrorMessage = ImagesControl.data().translationExtErrorMessage;
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

          Messages.makeError(maxExceededMessage);
          $(inputFile).val('');
        };

        if (extError) {
          Messages.makeError(extErrorMessage);
          $(inputFile).val('');
        };

      });

    }

}

module.exports = ImagesControl;
