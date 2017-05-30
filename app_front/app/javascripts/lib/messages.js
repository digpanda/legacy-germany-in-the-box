/**
 * Messages Class
 */
var Messages = {

    shown: false,

    makeError: function(error) {

      $('#message-container-error').show();
      $("#message-content-error").html(error);
      Messages.activateHide('#message-container-error', 3000);
      Messages.shown = true;

    },

    makeSuccess: function(success) {

      $('#message-container-success').show();
      $("#message-content-success").html(success);
      Messages.activateHide('#message-container-success', 4000);
      Messages.shown = true;

    },

    /**
     * Everything below is called from the starter messages.js
     */

    activateHide: function(el, time) {

      setTimeout(function(){
          $(el).fadeOut(function() {
            $(document).trigger('message:hidden');
          });
      }, time);

    },

    forceHide: function(el) {
      $('body').on('click', function() {
        console.log(Messages.shown);
        if (Messages.shown) {
          Messages.activateHide(el, 0);
          Messages.shown = false;
        }
      })
    },

}

module.exports = Messages;
