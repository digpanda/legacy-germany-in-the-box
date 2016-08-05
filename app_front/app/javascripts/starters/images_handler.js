/**
 * ImagesHandler Class
 */
var ImagesHandler = {

    /**
     * Initializer
     */
    init: function() {

      this.startImagesHandler();

    },

    /**
     * 
     */
    startImagesHandler: function() {

      if ($(".img-file-upload").length > 0) {

        $(".img-file-upload").each(function() {
          var fileElement = $(this)
          $(this).change(function(event){
            var input = $(event.currentTarget);
            var file = input[0].files[0];
            var reader = new FileReader();
            reader.onload = function(e){
              var image_base64 = e.target.result;
              $(fileElement.attr('img_id')).attr("src", image_base64);
            };
            reader.readAsDataURL(file);
          });
        });

      }
      
    },

}

module.exports = ImagesHandler;

