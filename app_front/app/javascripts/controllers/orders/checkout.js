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

    let bankDetails = $("#bank-details").data();
    let parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

    PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);

  },

}

module.exports = Checkout;