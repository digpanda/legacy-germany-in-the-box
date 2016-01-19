module ProductsHelper
  def generate_add_product_to_collection_js(collection_id, product_id)
    %Q{
      $.ajax({
          dataType: 'json',
          url: "#{add_product_to_collection_path(collection_id, product_id)}",
          async: true,
          success: function(json) {

          }
     });
    }
  end
end
