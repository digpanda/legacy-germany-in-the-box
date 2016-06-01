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

      self = this;

      $(".js-heart-click").on("click", function(e) {

        e.preventDefault();

        let productId = $(this).attr('data-product-id');
        let favorite = $(this).attr('data-favorite'); // Should be converted

        if (favorite == '1') {

          // We remove the favorite front data
          $(this).removeClass('+red');
          $(this).attr('data-favorite', '0');
          
          ProductFavorite.doUnlike(this, productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        } else {

          // We change the style before the callback for speed reason
          $(this).addClass('+red');
          $(this).attr('data-favorite', '1');

          ProductFavorite.doLike(this, productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        }

      });

    },

    doLike: function(el, productId, callback) {

      $.ajax({
        method: "PATCH",
        url: "/products/"+productId+"/like",
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

      $.ajax({
        method: "PATCH",
        url: "/products/"+productId+"/unlike",
        data: {}

      }).done(function(res) {

        callback(res);

      });

    },
}

module.exports = ProductFavorite;