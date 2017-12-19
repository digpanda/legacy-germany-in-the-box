/**
 * Device Class
 */
var Device = {

    mobile_size: 992,
    current_window: null,

    /**
     * Initializer
     */
    init: function() {
      this.handleResize();
    },


    /**
    * Check if window is mobile or desktop
    * And will refresh dependinf the size
    */
    handleResize: function() {
      Device.check();
      $(window).resize(Device.check);
    },

    check: function() {
      if (Device.width() < Device.mobile_size) {
        // mobile size
        $('#js-device').data('current', 'mobile')
      } else {
        // desktop size
        $('#js-device').data('current', 'desktop')
      }
    },

    width: function() {
      return $(window).width()
    }

}

module.exports = Device;
