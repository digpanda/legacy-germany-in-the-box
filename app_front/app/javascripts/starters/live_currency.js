/**
 * LiveCurrency Class
 */
var LiveCurrency = {

   to_euro: 0.0,
   to_yuan: 0.0,

    /**
     * Initializer
     */
    init: function() {

      this.setupLiveCurrency();
      this.handleDisplay();

    },

    /**
     *
     */
    setupLiveCurrency: function() {

      let ExchangeRate = require("javascripts/models/exchange_rate");

      ExchangeRate.show(function(res) {
        LiveCurrency.to_euro = parseFloat(res.data.to_euro);
        LiveCurrency.to_yuan = parseFloat(res.data.to_yuan);
      })

    },

    handleDisplay: function() {

      // initialize your tooltip as usual:
      $('.js-currency').tooltipster({});

      $('.js-currency').on('keyup', function(e) {
        let current = parseFloat($(this).val());

        if (isNaN(current)) {
          current = 0.0;
        }

        let in_yuan = current * LiveCurrency.to_yuan;
        // at some point you may decide to update its content:
        $(this).tooltipster('content', `EUR ${current} = CNY ${in_yuan}`);
        $(this).tooltipster('open');

      })

    },

}

module.exports = LiveCurrency;
