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

        console.log('raw data favorite : ' + $(this).attr('data-favorite'));
        console.log('id: '+ $(this).attr('id'));

        console.log('favorite : ' + favorite);

        if (favorite == '1') {

          // We remove the favorite front data
          $(this).removeClass('+red');
          $(this).attr('data-favorite', '0'); // marche pas
          //$(this).data('favorite', '0') // marche pas non plus

          ProductFavorite.doUnlike(productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });
        } else {

          // We change the style before the callback for speed reason
          $(this).addClass('+red');
          $(this).attr('data-favorite', '1');

          ProductFavorite.doLike(productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        }

      });

    },

    doLike: function(productId, callback) {

      $.ajax({
        method: "PATCH",
        url: "/products/"+productId+"/like",
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

    doUnlike: function(productId, callback) {

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