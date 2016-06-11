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

      if ($("#js-message-error").length > 0) {
        Messages.activateHide('#js-message-error', 3000);
      }

      if ($("#js-message-success").length > 0) {
        Messages.activateHide('#js-message-error', 4000);
      }

    },

    activateHide: function(el, time) {

      setTimeout(function(){
          $(el).fadeOut();
      }, time);

    },

}

module.exports = Messages;
