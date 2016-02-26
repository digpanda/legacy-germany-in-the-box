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
      $('#create_and_add_to_collection_form_input_name_#{product_id}').each(function() {
        if($(this).val()){
          $.ajax({
            type: 'POST',
            url: '#{create_and_add_collections_path}',
            data: $('#create_and_add_to_collection_form_#{product_id}').serialize(),
            success: function(json) {
              $('#create_and_add_to_collection_dropdown_button_#{product_id}').click()
            }
          });
        } else {
          $(this).css("border","1px solid red");
        }
      });

      return false;
    }
  end

  def enough_inventory(sku, quantity)
    return sku && (not sku.limited or sku.quantity >= quantity )
  end


  def get_options_list(v)
    v.options.map { |o| [o.get_locale_name, o.id] }
  end

  def get_grouped_categories_options
    categories = []

    Category.roots.each do |rc|
      categories += rc.children
    end

    categories.map {|rc| [rc.name, rc.children.map {|cc| [cc.name, cc.id.to_s]} ] }.to_a
  end
end
