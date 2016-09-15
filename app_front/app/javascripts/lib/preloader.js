/**
* Preloader Class
*/
var Preloader = {

  /**
  * Check an element and hide it until the trigger is loaded itself
  * Show a loder `.js-loader` if possible
  */
  dispatchLoader: function(element, loader_selector, trigger) {

    $(loader_selector).show();
    $(element).hide();

    $(trigger).load(function() {
      $(loader_selector).hide();
      $(element).show();
    })

  },

}

module.exports = Preloader;
