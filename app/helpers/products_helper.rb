module ProductsHelper
  def generate_toggle_product_in_collection_js(collection_id, product_id)
    %Q{
      $.ajax({
          dataType: 'json',
          url: "#{toggle_product_in_collection_path(collection_id, product_id)}",
          async: true,
          success: function(json) {
            $.ajax({
                dataType: 'json',
                url: "#{is_product_in_user_collections_path(product_id)}",
                async: true,
                success: function(json) {
                  if (json['contained'] === 'true') {
                    $("#dropdown_toggle_#{product_id}").removeClass('btn-primary')
                    $("#dropdown_toggle_#{product_id}").addClass('btn-success')
                  } else {
                    $("#dropdown_toggle_#{product_id}").removeClass('btn-success')
                    $("#dropdown_toggle_#{product_id}").addClass('btn-primary')
                  }
                }
           });
          }
     });
    }
  end
end
