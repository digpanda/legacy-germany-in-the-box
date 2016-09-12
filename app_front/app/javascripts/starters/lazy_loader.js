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

      $(".lazy").Lazy({
          // callback
          beforeLoad: function(element) {
              console.log("start loading " + element.prop("tagName"));
          },

          // custom loaders
          customLoaderName: function(element) {
              element.html("element handled by custom loader");
              element.load();
          },
          asyncLoader: function(element, response) {
              setTimeout(function() {
                  element.html("element handled by async loader");
                  response(true);
              }, 1000);
          }
      });

    },

}

module.exports = LazyLoader;
