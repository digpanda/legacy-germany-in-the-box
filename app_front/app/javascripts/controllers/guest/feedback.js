/**
 * GuestFeedback Class
 */
var GuestFeedback = {

    /**
     * Initializer
     */
    init: function() {

      var Preloader = require("javascripts/lib/preloader");
      Preloader.dispatchLoader('#external-script','.js-loader', 'iframe#WJ_survey');

    },

}

module.exports = GuestFeedback;
