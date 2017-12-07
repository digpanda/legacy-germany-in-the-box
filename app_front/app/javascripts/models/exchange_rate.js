/**
 * ExchangeRate Class
 */
var ExchangeRate = {

  /**
   * Get the total number of products within the cart
   */
  show: function(callback) {

    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/admin/exchange_rate",
      data: {}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({success: false, error: err.responseJSON.error});

    });

  },

};

module.exports = ExchangeRate;
