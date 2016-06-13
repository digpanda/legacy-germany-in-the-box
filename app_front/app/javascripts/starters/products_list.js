/**
 * ProductsList Class
 */
var ProductsList = {

    /**
     * Initializer
     */
    init: function() {

      this.manageProductsWall();

    },

    manageProductsWall: function() {

      if ($('#freewall-products').length > 0) {

        var wall;

        wall = new freewall("#freewall-products");

        wall.reset({
          selector: '.js-brick',
          delay: 0,
          animate: false,
          cellW: 260,
          cellH: 'auto',
          onResize: function() {
            return wall.fitWidth();
          }
        });

        wall.fitWidth();
        $('#freewall-products').hide();

        /*wall.container.find('.js-brick img:first').load(function() {
          return wall.fitWidth();
        });*/
        wall.container.find('.js-brick img:last').load(function() {
          $('#freewall-products').show();
          wall.fitWidth();
        });

        $(window).trigger('resize');

     }

    },

}

module.exports = ProductsList;