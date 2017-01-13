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

      $('.navmenu')
          .on('show.bs.offcanvas', function () {
          console.log('show');
          $('.canvas').addClass('sliding');
      })
          .on('shown.bs.offcanvas', function () {
          console.log('shown');
      })
          .on('hide.bs.offcanvas', function () {
          $('.canvas').removeClass('sliding');
              console.log('hide');
      })
          .on('hidden.bs.offcanvas', function () {
          console.log('hidden');
      });
    },

}

module.exports = MobileMenu;
