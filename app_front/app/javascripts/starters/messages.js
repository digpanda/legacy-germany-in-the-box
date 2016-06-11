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
        Messages.activateHide('#message-error', 3000);
      }

      if ($("#message-success").length > 0) {
        Messages.activateHide('#message-success', 4000);
      }

    },

}

module.exports = Messages;
