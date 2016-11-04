/**
 * Messages Class
 */
var Messages = {

    /**
     * Initializer
     */
    init: function() {

      this.hideMessages();

    },

    /**
     *
     */
    hideMessages: function() {

      let Messages = require("javascripts/lib/messages");

      if ($("#message-error").length > 0) {
        Messages.activateHide('#message-error', 5000);
      }

      if ($("#message-success").length > 0) {
        Messages.activateHide('#message-success', 6000);
      }

    },

}

module.exports = Messages;
