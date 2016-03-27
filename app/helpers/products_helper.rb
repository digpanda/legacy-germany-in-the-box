module ProductsHelper
  include FunctionCache

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

  def gen_add_target_group
    %Q{
      var body = $('#table_shop_target_groups_#{@shop.id}').find('tbody')
      if (body.children().length < #{Rails.configuration.max_num_target_groups}) {
        body.append(
          $('<tr>').addClass('form-group').append(
            $('<td>').attr('width', '80%').append(
              $('<input>').attr('name', 'shop[target_groups][]').attr('required', true).attr('placeholder', '#{I18n.t(:target_group, scope: :edit_shop)}').addClass('form-control dynamical_required').attr('maxLength', #{Rails.configuration.max_short_text_length})
            ),
            $('<td>').attr('width', '20%').append(
              $('<a>').attr('href', '#').addClass('btn').attr('onclick', #{gen_remove_target_group}).append(
                $('<i>').addClass('fa').addClass('fa-times-circle'),
                ' #{I18n.t(:remove_target_group, scope: :edit_shop)}'
              )
            )
          )
        );
      }

      return false;
    }
  end

  def gen_remove_target_group
    %Q{
      "$(this).closest('tr').remove(); return false;"
    }
  end

  def gen_add_sales_channel
    %Q{
      var body = $('#table_shop_sales_channels_#{@shop.id}').find('tbody')
      if (body.children().length < #{Rails.configuration.max_num_sales_channels}) {
        body.append(
          $('<tr>').append(
            #{gen_sales_channel_select_tag},
            $('<td>').addClass('form-group').attr('width', '60%').append(
              $('<input>').attr('name', 'shop[sales_channels][]').attr('required', true).attr('placeholder', '#{I18n.t(:sales_channel, scope: :edit_shop)}').addClass('form-control dynamical_required').attr('maxLength', #{Rails.configuration.max_short_text_length})
            ),
            $('<td>').attr('width', '20%').append(
              $('<a>').attr('href', '#').addClass('btn').attr('onclick', #{gen_remove_sales_channel}).append(
                $('<i>').addClass('fa').addClass('fa-times-circle'),
                ' #{I18n.t(:remove_sales_channel, scope: :edit_shop)}'
              )
            )
          )
        );
      }

      return false;
    }
  end

  def gen_remove_sales_channel
    %Q{
      "$(this).closest('tr').remove(); return false;"
    }
  end

  def gen_sales_channel_select_tag
    %Q{
      $('<td>').attr('width', '20%').append(
        $('<select>').attr('name', 'shop[sales_channels][]').addClass('form-control').append(
          $('<option>').val('Online-Shop').text('Online-Shop'),
          $('<option>').val('Online-Marktplatz').text('Online-Marktplatz'),
          $('<option>').val('Einzelhandler').text('Einzelhandler'),
          $('<option>').val('Workshop').text('Workshop')
        )
      )
    }
  end

  def gen_remove_variant_panel
    %Q{
      function () {
        $(this).closest('.panel').remove(); return false;
      }
    }
  end

  def gen_remove_option_panel
    %Q{
      function() {
        $(this).closest('.form-inline').remove(); return false;
      }
    }
  end

  def gen_add_option_to_existing_variant
    %Q{
      var parent_index = $(this).attr('index')
      var body = $(this).closest('.panel').find('.panel-body');
      var index = body.children('input').length;

      body.append(
        $('<div>').addClass('form-inline').append(
          $('<div>').addClass('form-group').append(
            $('<input>').attr('style', 'max-width:120px').attr('name', 'product[options_attributes][' + parent_index + '][suboptions_attributes][' + index + '][name]').addClass('form-control dynamical_required').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{I18n.t(:option_name, scope: :edit_product_variant)}')
          ),
          ' ',
          $('<div>').addClass('btn-group pull-right').append(
            $('<a>').addClass('fa fa-times-circle btn').attr('title', '#{I18n.t(:remove, scope: :edit_product_variant)}').click(#{gen_remove_option_panel})
          )
        )
      );

      return false;
    }
  end

  def gen_add_option_to_new_variant
    %Q{
      function() {
        var parent_index = $('#variants_panel_#{@product.id}').find('.panel-body:first').find('.panel').not($(this).closest('.panel')).length;
        var body = $(this).closest('.panel').children('.panel-body');
        var index = body.find('input').length;
        body.append(
          $('<div>').addClass('form-inline').append(
            $('<div>').addClass('form-group').append(
              $('<input>').attr('style', 'max-width:120px').attr('name', 'product[options_attributes]['+parent_index+'][suboptions_attributes][' + index + '][name]').addClass('form-control dynamical_required input-sm').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{I18n.t(:option_name, scope: :edit_product_variant)}')
            ),
            ' ',
            $('<div>').addClass('btn-group pull-right').append(
              $('<a>').addClass('fa fa-times-circle btn').attr('title', '#{I18n.t(:remove, scope: :edit_product_variant)}').click(#{gen_remove_option_panel})
            )
          )
        );

        return false;
      }
    }
  end

  def gen_add_variant_panel
    %Q{
      var body = $('#variants_panel_#{@product.id}').find('.panel-body:first')
      var index = body.find('.panel').length
      if (index < #{Rails.configuration.max_num_variants}) {
        body.append(
          $('<div>').addClass('col-md-4').append(
            $('<div>').addClass('panel panel-info').append(
              $('<div>').addClass('panel-heading').append(
                $('<div>').addClass('form-inline').append(
                  $('<div>').addClass('form-group').append(
                    $('<input>').attr('name', 'product[options_attributes]['+index+'][name]').attr('required', true).attr('style', 'max-width:120px').addClass('form-control input-sm dynamical_required').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{I18n.t(:variant_name, scope: :edit_product_variant)}')
                  ),
                  ' ',
                  $('<div>').addClass('btn-group pull-right').append(
                    $('<a>').addClass('fa fa-times-circle btn').click(#{gen_remove_variant_panel}).attr('title', '#{I18n.t(:remove, scope: :edit_product_variant)}'),
                    $('<a>').addClass('fa fa-plus btn').click(#{gen_add_option_to_new_variant}).attr('title', '#{I18n.t(:new_option, scope: :edit_product_variant)}')
                  )
                )
              ),
              $('<div>').addClass('panel-body')
            )
          )
        );
      }

      return false;
    }
  end

  def enough_inventory(sku, quantity)
    return sku && (not sku.limited or sku.quantity >= quantity )
  end

  def get_options_for_select(product)
    skus = product.skus.is_active.in_stock
    values = skus.map { |s| s.option_ids.compact.join(',') }
    names  = skus.map do |s|
      s.option_ids.compact.map do |oid|
        o = product.options.detect { |v| v.suboptions.find(oid) }.suboptions.find(oid)
        o.get_locale_name
      end.join(', ')
    end
    values.each_with_index.map { |v,i| [names[i], v] }
  end

  def get_options_json(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      { name: v.name, name_locales: v.name_locales, option: { id: o.id, name: o.name, name_locales: o.name_locales } }
    end
  end

  def get_grouped_categories_options
    get_grouped_categories_options_from_cache
  end

  def get_grouped_variants_options(product)
    get_grouped_variants_options_from_cache(product)
  end
end
