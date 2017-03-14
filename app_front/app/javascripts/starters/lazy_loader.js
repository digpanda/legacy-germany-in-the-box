/**
 * LazyLoader Class
 */
var LazyLoader = {

    /**
     * Initializer
     */
    init: function() {

      this.startLazyLoader();

    },

    /**
     *
     */
    startLazyLoader: function() {

      $("div.lazy").lazyload({
          effect : "fadeIn",
          threshold : 400
      });

    },

}

module.exports = LazyLoader;
