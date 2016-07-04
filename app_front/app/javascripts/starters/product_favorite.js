/**
 * ProductFavorite Class
 */
var ProductFavorite = {

    /**
     * Initializer
     */
    init: function() {

      this.manageHeartClick();

    },

    /**
     * When the heart is clicked
     */
    manageHeartClick: function() {

      var self = this;

      $(".js-heart-click").on("click", function(e) {

        e.preventDefault();

        let productId = $(this).attr('data-product-id');
        let favorite = $(this).attr('data-favorite'); // Should be converted

        if (favorite == '1') {

          // We remove the favorite front data
          $(this).removeClass('+red');
          $(this).addClass('+grey');
          $(this).attr('data-favorite', '0');
          
          ProductFavorite.doUnlike(this, productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        } else {

          // We change the style before the callback for speed reason
          $(this).addClass('+red');
          $(this).removeClass('+grey');
          $(this).attr('data-favorite', '1');

          ProductFavorite.doLike(this, productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        }

      });

    },

    doLike: function(el, productId, callback) {

      // We should move it to front-end models
      $.ajax({
        method: "PUT",
        url: "/api/customer/favorites/"+productId,
        data: {}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        // If it's a Unauthorized code, it means we are not logged in, let's trigger.
        if (err.status == 401) {
          
          $(el).removeClass('+red');
          $("#sign_in_link").click();

        }

      });

    },

    doUnlike: function(el, productId, callback) {
      
      // We should move it to front-end models
      $.ajax({
        method: "DELETE",
        url: "/api/customer/favorites/"+productId,
        data: {}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        console.error(err.responseJSON.error);

      });

    },
}

module.exports = ProductFavorite;