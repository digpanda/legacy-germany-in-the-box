/**
 * MobileMenu Class
 */
var MobileMenu = {

    /**
     * Initializer
     */
    init: function() {

      this.startMobileMenu();

    },

    /**
     *
     */
    startMobileMenu: function() {

      this.manageFade();

    },

    manageFade: function() {

      $('.navmenu')
          .on('show.bs.offcanvas', function () {
          console.log('show');
          $('.canvas').addClass('sliding');
      })
          .on('shown.bs.offcanvas', function () {
      })
          .on('hide.bs.offcanvas', function () {
          $('.canvas').removeClass('sliding');
      })
          .on('hidden.bs.offcanvas', function () {
          console.log('hidden');
      });
      
    }

}

module.exports = MobileMenu;
