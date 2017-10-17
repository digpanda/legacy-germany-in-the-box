/**
 * Order Class
 */
var Order = {

  /**
   * Check if user is auth or not via API call
   */
  update: function(orderId, params, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/customer/orders/"+orderId,
      data: {order: params}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({success: false, error: err.responseJSON.error});

    });

  },
}

module.exports = Order;
