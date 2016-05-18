/**
 * ProductFavorite Class
 */
var ProductFavorite = {

    /**
     * Initializer
     */
    init: function() {

      // Variable sets
      this.product = $('#js-product').data();

      this.manageHeartClick();

    },

    /**
     * When the heart is clicked
     */
    manageHeartClick: function() {

      self = this;

      $(".js-heart-click").on("click", function(e) {

        e.preventDefault();

        ProductFavorite.doLike(ProductFavorite.product.id, function(res) {

          console.log(res);

        });

      });

    },

    doLike: function(product_id, callback) {

      $.ajax({
        method: "PATCH",
        url: "/products/"+product_id+"/like",
        data: {}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        // If it's a Unauthorized code, it means we are not logged in, let's trigger.
        if (err.status == 401) {

          $("#sign_in_link").click();

        }

      });

    },

}

module.exports = ProductFavorite;