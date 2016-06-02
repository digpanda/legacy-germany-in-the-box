/**
 * User Class
 */
var User = {

  /**
   * Check if user is auth or not via API call
   */
  isAuth: function(callback) {

    $.ajax({
      method: "GET",
      url: "api/users/is_auth",
      data: {}

    }).done(function(res) {

      callback(res.is_auth);

    });

  },

}

module.exports = User;