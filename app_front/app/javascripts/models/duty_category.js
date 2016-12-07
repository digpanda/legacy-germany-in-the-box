/**
 * Duty Category Class
 */
var DutyCategory = {

  /**
   * Check if user is auth or not via API call
   */
  find: function(dutyCategoryId, callback) {

    $.ajax({
      method: "GET",
      url: "/api/admin/duty_categories/"+dutyCategoryId,
      data: {}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      callback({success: false, error: err.responseJSON.error});

    });

  },

}

module.exports = DutyCategory;
