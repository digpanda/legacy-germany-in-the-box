/**
 * ProductSku Class
 */
var ProductSku = {

  /**
   * Get the ProductSku details
   */
  show: function(productId, optionIds, callback) {

      $.ajax({

        method: "GET",
        url: '/api/guest/products/' + productId + '/skus/0', // 0 is to match with the norm ... hopefully when we go away from mongo there's no such things
        data: {option_ids: optionIds}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        callback({success: false, error: err.responseJSON.error});

      });

  },

  /**
   * Get all the Skus from the Product
   */
  all: function(productId, callback) {

      $.ajax({

        method: "GET",
        url: '/api/guest/products/' + productId + '/skus',
        data: {}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        callback({success: false, error: err.responseJSON.error});

      });

  },

}

module.exports = ProductSku;
