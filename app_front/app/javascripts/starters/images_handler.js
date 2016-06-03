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

      $(".img-file-upload").each(function() {
        var fileElement = $(this)
        $(this).change(function(event){
          var input = $(event.currentTarget);
          var file = input[0].files[0];
          var reader = new FileReader();
          reader.onload = function(e){
            image_base64 = e.target.result;
            $(fileElement.attr('img_id')).attr("src", image_base64);
          };
          reader.readAsDataURL(file);
        });
      });

      $("img").one("error", function(e){
        $(this).attr('src','/assets/no_image_available.jpg');
      });

    },

}

module.exports = ImagesHandler;

