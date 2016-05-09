/**
 * Apply Wirecard Class
 */
var Demo = {

  /**
   * Initializer
   */
  init: function() {

    $('#slider').lightSlider({
      "item": 1,
      "loop": true,
      "slideMargin": 0,
      "pager": false,
      "auto": true,
      "pause": "3000",
      "speed": "1000",
      "adaptiveHeight": true,
      "verticalHeight": 1000,
      "mode": "fade",
      "enableDrag": false,
      "enableTouch": true
    });

  },

}

module.exports = Demo;