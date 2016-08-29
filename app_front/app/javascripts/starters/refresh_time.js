/**
 * RefreshTime Class
 */
var RefreshTime = {

    /**
     * Initializer
     */
    init: function() {

      this.refreshTime('#server-time');
      this.refreshTime('#china-time');
      this.refreshTime('#germany-time');

    },

    /**
     * Change the current time html
     * @param  {#} selector
     * @return void
     */
    displayTime: function(selector) {
      let current = $(selector).html();
      let time = moment(current, 'HH:mm:ss').add('seconds', 1).format('HH:mm:ss');
      $(selector).html(time);
    },

    /**
     * Activate the time refresh for specific selector
     * @param  {#} selector
     * @return void
     */
    refreshTime: function(selector) {
      setInterval(function() {
        RefreshTime.displayTime(selector)
      }, 1000);
    },

}

module.exports = RefreshTime;
