/**
 * OrdersAddresses class
 */
var OrdersAddresses = {

  /**
   * Initializer
   */
  init: function() {

    this.newAddressForm();

  },

  /**
   * When someone clicks on "enter new address" a form will show up
   */
  newAddressForm: function() {

    $('#button-new-address').on('click', function(e) {

      $('#button-new-address').addClass('+hidden');
      $('#new-address').removeClass('+hidden');

      // we reset the sticky footer because it makes useless spaces
      var Footer = require('javascripts/starters/footer');
      Footer.processStickyFooter();

    });

  },

}

module.exports = OrdersAddresses;
