/**
 * CustomerGatewayCreate class
 */
var CustomerGatewayCreate = {

  /**
   * Initializer
   */
   init: function() {

    this.postBankDetails();

  },

  /**
   * Post bank details to the `form_url`
   */
   postBankDetails: function() {

    var Casing = require("javascripts/lib/casing");
    var PostForm = require("javascripts/lib/post_form.js");

    // If it's Wirecard
    if ($("#bank-details").length > 0) {

      let bankDetails = $("#bank-details")[0].dataset;
      let parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

      PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

    }

  },

}

module.exports = CustomerGatewayCreate;
