/**
 * ManageCart class
 */
var ManageCart = {

  /**
   * Initializer
   */
   init: function() {

    this.onSetAddress();

  },

  onSetAddress() {

    var self = this;

    $("#set_address_link").click(function(e) {

      e.preventDefault();
      self.forceLogin(this);

    });

  },

  /**
   * Send next destination and trigger log-in if not logged-in already
   */
   forceLogin: function(e) {

    var location = $("#set_address_link").attr("href");
    var self = this;

    this.isAuth(function(res) {

      // If the user isn't auth
      // We force the trigger and
      // Set the new location programmatically
      if (res === false) {

        self.setRedirectLocation(location);
        $("#sign_in_link").click();

      } else {

        // Else we just continue to do what we were doing
        $(e).submit();

      }

    });

  },

  isAuth: function(callback) {

    $.ajax({
      method: "GET",
      url: "/users/is_auth",
      data: {}

    }).done(function(res) {

      callback(res.is_auth);

    });

  },

  setRedirectLocation: function(location) {

    $.ajax({
      method: "PATCH",
      url: "/set_redirect_location",
      data: {"location": location}


    }).done(function(res) {

      // callback {"status": "ok"}

    });

  },

}

module.exports = ManageCart;