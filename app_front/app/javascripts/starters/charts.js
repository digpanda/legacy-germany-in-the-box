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
       let metadata = $(this).data('metadata');
       Charts.renderChart(action, metadata, $(this));
     });
   },

   renderChart: function(action, metadata, target) {
     ChartModel.get(action, metadata, function(res) {
       Charts.pluginNumbers();
      new Chart(target, res.data);
     });
   },

   pluginNumbers: function() {

     // Define a plugin to provide data labels
     Chart.plugins.register({
       afterDatasetsDraw: function(chart, easing) {
         // To only draw at the end of animation, check for easing === 1
         var ctx = chart.ctx;

         // Numbers option is on
         if (chart.data.numbers) {

           chart.data.datasets.forEach(function (dataset, i) {
             var meta = chart.getDatasetMeta(i);
             if (!meta.hidden) {
               meta.data.forEach(function(element, index) {
                 // Draw the text in black, with the specified font
                 ctx.fillStyle = dataset.backgroundColor;

                 var fontSize = 14;
                 var fontStyle = 'bold';
                 var fontFamily = 'Helvetica Neue';
                 ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

                 // Just naively convert to string for now
                 var dataString = dataset.data[index].toString();

                 // Make sure alignment settings are correct
                 ctx.textAlign = 'center';
                 ctx.textBaseline = 'middle';

                 var padding = 5;
                 var position = element.tooltipPosition();
                 ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
               });
             }
           });
         }

       }
     });

   }

 }

module.exports = Charts;
