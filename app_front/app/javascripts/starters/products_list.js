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

        var wall = new freewall("#freewall-products");

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

        wall.container.find('.js-brick img').load(function() {
          $(window).trigger('resize');
        });

        $(window).trigger('resize');

     }

    },

}

module.exports = ProductsList;