/**
 * AutoResize Class
 */
var AutoResize = {

    /**
     * Initializer
     */
    init: function() {

      this.setupAutoResize();

    },

    setupAutoResize: function() {

      $('textarea').textareaAutoSize();

    },
}

module.exports = AutoResize;
