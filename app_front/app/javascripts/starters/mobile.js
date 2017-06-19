/**
 * AutoResize Class
 */
var AutoResize = {

    /**
     * Initializer
     */
    init: function() {

      this.setupInternational();

    },

    setupInternational: function() {

      $("#user_mobile").intlTelInput({
        nationalMode: false
      });

    },
}

module.exports = AutoResize;
