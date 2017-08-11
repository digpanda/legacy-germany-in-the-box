/**
 * Link Class
 */
var Link = {

  /**
   * Get the total number of products within the cart
   */
  wechat: function(raw_url, callback) {

    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/admin/links/wechat",
      data: {raw_url: raw_url}

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

module.exports = Link;
