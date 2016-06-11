/**
 * OrderItem Class
 */
var OrderItem = {

  /**
   * Check if user is auth or not via API call
   */
  setQuantity: function(orderItemId, quantity ,callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/order_items/"+orderItemId+"/set_quantity",
      data: {"quantity" : quantity}

    }).done(function(res) {

      callback(res);

    });

  },

}

module.exports = OrderItem;