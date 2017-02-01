/**
 * OrderItem Class
 */
var OrderItem = {

  /**
   * Check if user is auth or not via API call
   */
  setQuantity: function(orderItemId, quantity, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/order_items/"+orderItemId,
      data: {"quantity" : quantity}

    }).done(function(res) {

      callback(res);

    }).error(function(err) {

      callback({success: false, error: err.responseJSON.error});

    });

  },

  addProduct: function(productId, quantity, optionIds, callback) {
    $.ajax({
        method: "POST",
        url: "/api/guest/order_items",
        data: {product_id: productId, quantity: quantity, option_ids: optionIds}

    }).done(function(res) {

        callback(res);

    }).error(function(err) {

        callback({success: false, error: err.responseJSON.error});

    });
  }

};

module.exports = OrderItem;
