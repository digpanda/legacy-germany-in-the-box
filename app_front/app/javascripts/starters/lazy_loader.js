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

      console.log('lazy');
      $("div.lazy").lazyload({
          effect : "fadeIn"
      });

    },

}

module.exports = LazyLoader;
