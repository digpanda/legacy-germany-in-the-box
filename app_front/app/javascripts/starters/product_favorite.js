var Translation = require('javascripts/lib/translation');

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

      $(el).find('i').addClass('+pink');
      $(el).find('i').removeClass('+grey');
      $(el).attr('data-favorite', '1');
      $(el).find('span').html(Translation.find('remove', 'favorites'))

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

      $(el).find('i').addClass('+grey');
      $(el).find('i').removeClass('+pink');
      $(el).attr('data-favorite', '0');
      $(el).find('span').html(Translation.find('add', 'favorites'))

    },
}

module.exports = ProductFavorite;
