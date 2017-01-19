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
          ProductFavorite.doUnlikeDisplay(this);
          ProductFavorite.doUnlike(productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        } else {

          // We change the style before the callback for speed reason
          ProductFavorite.doLikeDisplay(this);
          ProductFavorite.doLike(productId, function(res) {

            let favoritesCount = res.favorites.length;
            $('#total-likes').html(favoritesCount);

          });

        }

      });

    },

    doLike: function(productId, callback) {

      var Product = require("javascripts/models/product");
      var Messages = require("javascripts/lib/messages");

      Product.like(productId, function(res) {

        if (res.success === false) {

          Messages.makeError(res.error);

        } else {

          callback(res);

        }

      });

    },

    doLikeDisplay: function(el) {

      $(el).addClass('+pink');
      $(el).find('i').removeClass('fa-heart-o');
      $(el).find('i').addClass('fa-heart');
      $(el).removeClass('+grey');
      $(el).attr('data-favorite', '1');

    },

    doUnlike: function(productId, callback) {

      var Product = require("javascripts/models/product");
      var Messages = require("javascripts/lib/messages");

      Product.unlike(productId, function(res) {

        if (res.success === false) {

          Messages.makeError(res.error);

        } else {

          callback(res);

        }

      });

    },

    doUnlikeDisplay: function(el) {

      $(el).removeClass('+pink');
      $(el).addClass('+grey');
      $(el).find('i').addClass('fa-heart-o');
      $(el).find('i').removeClass('fa-heart');
      $(el).attr('data-favorite', '0');

    },
}

module.exports = ProductFavorite;
