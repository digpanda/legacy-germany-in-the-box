/**
 * NavigationModel Class
 */
var NavigationModel = {

  /**
   * Check if user is auth or not via API call
   */
  setLocation: function(location, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/navigation/",
      data: {"location" : location}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      callback({success: false, error: err.responseJSON.error});

    });

  },

}

module.exports = NavigationModel;
