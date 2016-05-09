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
      "mode": "fade",
      "enableDrag": false,
      "enableTouch": true
    });

   $(".flexnav").flexNav({

    'animationSpeed':     50,            // default for drop down animation speed
    'transitionOpacity':  false,           // default for opacity animation
    'buttonSelector':     '.menu-button', // default menu button class name
    'hoverIntent':        false,          // Change to true for use with hoverIntent plugin
    'hoverIntentTimeout': 150,            // hoverIntent default timeout
    'calcItemWidths':     false,          // dynamically calcs top level nav item widths
    'hover':              true            // would you like hover support?      
    
  });

  },

}

module.exports = Demo;