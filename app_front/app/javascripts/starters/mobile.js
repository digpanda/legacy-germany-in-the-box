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

      let config = {
        nationalMode: false,
        preferredCountries: ["DE", "CN"],
        initialCountry: "CN",
        onlyCountries: ["at", "au", "be", "ba", "bg", "ca", "ch", "cn", "cz", "de", "dk", "es",
                        "fi", "fr", "gb", "gr", "hr", "hu", "ie", "it", "lu", "nl", "no", "pl", "pt", "ro",
                        "ru", "sg", "sk", "si",  "se",  "ua", "us"]
      }

      $("#user_mobile").intlTelInput(config);
      $("#inquiry_mobile").intlTelInput(config);
      $("#address_mobile").intlTelInput(config);
      $("#shop_application_mobile").intlTelInput(config);
      $("#shop_application_tel").intlTelInput(config);

    },
}

module.exports = AutoResize;
