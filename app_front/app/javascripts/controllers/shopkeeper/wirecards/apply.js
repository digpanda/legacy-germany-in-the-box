/**
 * Apply Wirecard Class
 */
var ShopkeeperWirecardApply = {

  /**
   * Initializer
   */
   init: function() {

    this.postShopDetails();

  },

  /**
   * Post shop details to the `form_url`
   */
   postShopDetails: function() {

    var Casing = require("javascripts/lib/casing");
    var PostForm = require("javascripts/lib/post_form.js");

    let shopDetails = $("#shop-details").data();
    let parsedShopDetails = Casing.objectToUnderscoreCase(shopDetails);

    PostForm.send(parsedShopDetails, parsedShopDetails['form_url']);

  },

}

module.exports = ShopkeeperWirecardApply;
