/**
 * Bootstrap Class
 */
var Bootstrap = {

    /**
     * Initializer
     */
    init: function() {

      this.startPopover();
      this.startTooltip();

    },

    /**
     * 
     */
    startPopover: function() {

      $("a[rel~=popover], .has-popover").popover();
          
    },

    startTooltip: function() {

      $("a[rel~=tooltip], .has-tooltip").tooltip();
          
    },

}

module.exports = Bootstrap;


