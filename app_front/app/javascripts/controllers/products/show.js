/**
 * ProductsShow Class
 */
var ProductsShow = {

  /**
   * Initializer
   */
  init: function() {

    $('#gallery a').on('click', function(e) {

      /**
       * Homemade Gallery System by Laurent
       */
      e.preventDefault();

      $('#main_image').attr('src', $(this).data('image'));

      $('#main_image').magnify({
        speed: 0,
        src: $(this).data('zoom-image'),
      });


    });

    $('#gallery a:first').trigger('click');

  },

}

module.exports = ProductsShow;
