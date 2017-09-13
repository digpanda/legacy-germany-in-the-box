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

      $('.tooltipster-click').tooltipster({
         animation: 'fade',
         delay: 200,
         trigger: 'click',
         maxWidth: 350,
         timer: 1000
      });

      $('.tooltipster').tooltipster({
        'maxWidth': 350
      });

    },


}

module.exports = Tooltipster;
