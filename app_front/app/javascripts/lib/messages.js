/**
 * Messages Class
 */
var Messages = { // NOTE : We should use a template system to handle the HTML here

    makeError: function(error) {

      $("#messages-container").html('<div id="message-error" class="col-md-6 col-md-push-3 col-md-pull-3 message__error +centered">'+error+'</div>');
      Messages.activateHide('#message-error', 3000);
      
    },

    makeSuccess: function(success) {

      $("#messages-container").html('<div id="message-success" class="col-md-6 col-md-push-3 col-md-pull-3 message__success +centered">'+success+'</div>');
      Messages.activateHide('#message-success', 4000);
    
    },

    activateHide: function(el, time) {

      setTimeout(function(){
          $(el).fadeOut();
      }, time);

    },

}

module.exports = Messages;