/**
 * ProductSku Class
 */
var ProductSku = {

  /**
   * Get the ProductSku details
   */
  show: function(productId, optionIds, callback) {

      console.log(option_ids);

      $.ajax({

        method: "GET",
        url: '/api/guest/products/' + productId + '/show_sku',
        data: {option_ids: optionIds}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        callback({success: false, error: err.responseJSON.error});

      });

  },

}

module.exports = ProductSku;
