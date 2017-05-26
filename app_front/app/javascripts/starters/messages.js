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

      if ($("#message-container-error").length > 0) {
        Messages.activateHide('#message-container-error', 4000);
        Messages.forceHide('#message-container-error');
      }

      if ($("#message-container-success").length > 0) {
        Messages.activateHide('#message-container-success', 5000);
        Messages.forceHide('#message-container-success')
      }

    },

}

module.exports = Messages;
