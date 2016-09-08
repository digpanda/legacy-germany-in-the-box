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
        console.log(res);
      });


    },

}

module.exports = Navigation;
