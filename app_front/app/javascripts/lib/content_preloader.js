/**
 * ContentPreloader Class
 */
var ContentPreloader = {

  /**
   * Preload some content inside the system
   * @param  {String} image new image source
   * @param  {String} loader_selector loader to display
   * @return {void}
   */
  process: function(selected_attr, loader_selector) {

    selected_attr.load(function() {
      $(loader_selector).hide();
      $(this).show();
    }).before(function() {
      $(loader_selector).show();
      $(this).hide();
    });

  },

}

module.exports = ContentPreloader;
