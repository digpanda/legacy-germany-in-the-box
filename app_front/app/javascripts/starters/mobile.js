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
        nationalMode: false,
        preferredCountries: ["DE", "CN"],
        initialCountry: "DE"
      });

      $("#address_mobile").intlTelInput({
        nationalMode: false,
        preferredCountries: ["DE", "CN"],
        initialCountry: "CN"
      });

    },
}

module.exports = AutoResize;
