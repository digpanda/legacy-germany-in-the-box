/**
 * Navigation Class
 */
var Navigation = {

    /**
     * Initializer
     */
    init: function() {

      this.storeNavigation();

    },

    /**
     * We send the navigation to the back-end
     */
    storeNavigation: function() {

      var NavigationModel = require("javascripts/models/navigation_model");
      NavigationModel.setLocation(window.location.href, function(res) {
        // Nothing yet
      });

      console.log('select to be moved elsewhere');
      $('select.nice').niceSelect();
      $('.overlay').on('click', function(e) {
        $('#mobile-menu-button').trigger('click');
      });
    },

}

module.exports = Navigation;
