/**
 * Product Class
 */
var Product = {

  /**
   * Like a product
   */
  like: function(productId, callback) {

      $.ajax({
        method: "PUT",
        url: "/api/customer/favorites/"+productId,
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

  /**
   * Unlike a product
   */
  unlike: function(productId, callback) {

      $.ajax({
        method: "DELETE",
        url: "/api/customer/favorites/"+productId,
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

}

module.exports = Product;
