/**
 * User Class
 */
var User = {

  /**
   * Check if user is auth or not via API call
   */
  isAuth: function(callback) { // NOT CURRENTLY IN USE IN THE SYSTEM (REMOVE COMMENT IF YOU ADD IT SOMEWHERE)

    $.ajax({
      method: "GET",
      url: "api/users/is_auth",
      data: {}

    }).done(function(res) {

      callback(res);

    });

  },

}

module.exports = User;