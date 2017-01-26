/**
 * Messages Class
 */
var Messages = { // NOTE : We should use a template system to handle the HTML here

    makeError: function(error) {

      $("#messages-container").html('<div id="message-error" class="col-xs-10 col-xs-push-1 col-md-4 col-md-push-4 col-md-pull-4 message message__error +centered">'+error+'</div>');
      Messages.activateHide('#message-error', 3000);

    },

    makeSuccess: function(success) {

      $("#messages-container").html('<div id="message-success" class="col-xs-10 col-xs-push-1 col-md-4 col-md-push-4 col-md-pull-4 message message__success +centered">'+success+'</div>');
      Messages.activateHide('#message-success', 4000);

    },

    activateHide: function(el, time) {

      setTimeout(function(){
          $(el).fadeOut(function() {
            $(document).trigger('message:hidden'); // To replace footer
          });
      }, time);

    },

}

module.exports = Messages;
