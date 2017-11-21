var Form = require('javascripts/lib/form');

/**
* GuestServicesShow Class
*/
var GuestServicesShow = {

  /**
  * Initializer
  */
  init: function() {

    // We make bootstrap-validator work even
    // if the service form is hidden in a lightbox
    Form.forceValidatorOnHiddenFields();

  },

}

module.exports = GuestServicesShow;
