/**
 * RefreshTime Class
 */
var RefreshTime = {

    /**
     * Initializer
     */
    init: function() {

      //this.refreshTime('#server-time', 'America/Los_Angeles');
      this.refreshTime('#china-time', 'Asia/Shanghai');
      this.refreshTime('#germany-time', 'Europe/Berlin');

    },

    /**
     * Change the current time html
     * @param  {#} selector
     * @return void
     */
    displayTime: function(selector, time_zone) {
      let time = moment().tz(time_zone).format('HH:mm:ss');
      $(selector).html(time);
    },

    /**
     * Activate the time refresh for specific selector
     * @param  {#} selector
     * @return void
     */
    refreshTime: function(selector, time_zone) {
      var remote_time = $(selector).html();
      if (typeof remote_time != "undefined") {
        setInterval(function() {
          RefreshTime.displayTime(selector, time_zone)
        }, 1000);
      }
    },

}

module.exports = RefreshTime;
