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

      $("#shop_application_mobile").intlTelInput({
        nationalMode: false,
        preferredCountries: ["DE", "CN"],
        initialCountry: "DE"
      });

      $("#shop_application_tel").intlTelInput({
        nationalMode: false,
        preferredCountries: ["DE", "CN"],
        initialCountry: "DE"
      });

    },
}

module.exports = AutoResize;
