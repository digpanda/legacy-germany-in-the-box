/**
 * Checkout class
 */
var Checkout = {

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

    let bankDetails = $("#bank-details").data();
    let parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

    //console.log(parsedBankDetails);
    PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

  },

}

module.exports = Checkout;