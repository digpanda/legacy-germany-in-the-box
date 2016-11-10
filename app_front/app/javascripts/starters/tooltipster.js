/**
 * Tooltipster Class
 */
var Tooltipster = {

    /**
     * Initializer
     */
    init: function() {

      this.activateTooltipster();

    },

    activateTooltipster: function() {

      $('.tooltipster').tooltipster({
        'maxWidth': 350
      });

    },


}

module.exports = Tooltipster;
