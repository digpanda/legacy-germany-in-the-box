/**
 * Chart Class
 */
var Chart = {

  /**
   * Get the total number of products within the cart
   */
  get: function(action, callback) {

    console.log(`/api/admin/charts/${action}`)
    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: `/api/admin/charts/${action}`,
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

module.exports = Chart;
