/**
 * Navigation Class
 */
var Navigation = {

    /**
     * Initializer
     */
    init: function() {

      if ($('#js-navigation-disabled').length == 0) {

        this.storeNavigation();
      }

    },

    /**
     * We send the navigation to the back-end
     */
    storeNavigation: function() {

      var NavigationModel = require("javascripts/models/navigation_model");
      NavigationModel.setLocation(window.location.href, function(res) {
        // Nothing yet
      });

    },

}

module.exports = Navigation;
