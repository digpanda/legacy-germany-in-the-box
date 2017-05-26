/**
 * Messages Class
 */
var Messages = { // NOTE : We should use a template system to handle the HTML here

    makeError: function(error) {

      $('#message-container-error').show();
      $("#message-content-error").html(error);
      Messages.activateHide('#message-container-error', 3000);
      Messages.forceHide('#message-container-error')

    },

    makeSuccess: function(success) {

      $('#message-container-success').show();
      $("#message-content-success").html(success);
      Messages.activateHide('#message-container-success', 4000);
      Messages.forceHide('#message-container-success')

    },

    activateHide: function(el, time) {

      setTimeout(function(){
          $(el).fadeOut(function() {
            $(document).trigger('message:hidden');
          });
      }, time);

    },

    forceHide: function(el) {
      $(el).on('click', function() {
        Messages.activateHide(el, 0);
      })
    },

}

module.exports = Messages;
