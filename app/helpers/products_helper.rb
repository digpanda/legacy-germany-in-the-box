module ProductsHelper
  def generate_toggle_product_in_collection_js(collection_id, product_id)
    %Q{
      $.ajax({
          dataType: 'json',
          url: '#{toggle_product_in_collection_path(collection_id, product_id)}',
          async: true,
          success: function(json) {
            checkboxes = $("[id^=collection_checkbox]")
            flag = false
            for (i=0; i<checkboxes.length; ++i) {
              if (checkboxes[i].checked ) {
                flag = true
                break
              }
            }

            if (flag) {
              $('#dropdown_toggle_#{product_id}').addClass('btn-success')
              $('#dropdown_toggle_#{product_id}').removeClass('btn-primary')
            } else {
              $('#dropdown_toggle_#{product_id}').addClass('btn-primary')
              $('#dropdown_toggle_#{product_id}').removeClass('btn-success')
            }
          }
     });
    }
  end

  def generate_create_and_add_to_collection_js(product_id)
    %Q{
      $.ajax({
        type: 'POST',
        url: '#{create_and_add_to_collection_path}',
        data: $('#create_and_add_to_collection_form_#{product_id}').serialize(),
        type: 'json'
        success: function(json) {
          $('#create_and_add_to_collection_dropdown_button_#{product_id}').click()
        }
      });

      return false;
    }
  end
end
