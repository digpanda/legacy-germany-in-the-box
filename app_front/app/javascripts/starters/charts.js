var ChartModel = require("javascripts/models/chart");
/**
 * Charts Class
 */
 var Charts = {

   /**
   * Initializer
   */
   init: function() {

     this.setupCharts();

   },

   /**
    * This will try to render any chart present on the HTML
    * <canvas class="js-chart" data-action="total_users" width="500" height="150"></canvas>
    */
   setupCharts: function() {

     // We will load one after the other each chart
     // with their matching action
     $('.js-chart').each(function(index, value) {
       let action = $(this).data('action');
       Charts.renderChart(action, $(this));
     });

   },

   renderChart: function(action, target) {
     ChartModel.get(action, function(res) {
      var myChart = new Chart(target, res.data);
     });
   }


 }

module.exports = Charts;
