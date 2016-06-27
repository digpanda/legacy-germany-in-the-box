module ProductsHelper
  include AppCache

  def gen_remove_variant_panel
    %Q{
      function () {
        if ( $(this).closest('.col-md-4').siblings().length > 0 ) {
          $(this).closest('.col-md-4').remove();
        }

        return false;
      }
    }
  end

  def gen_remove_option_panel
    %Q{
      function() {
        if ( $(this).closest('.form-inline').siblings().length > 0 ) {
         $(this).closest('.form-inline').remove();
        }
        return false;
      }
    }
  end

  def gen_add_option_to_existing_variant(placeholder)
    %Q{
      var pp_index = $(this).attr('index')
      var body = $(this).closest('.panel').children('.panel-body');
      var index = body.children('.form-inline').length;

      body.append(
        $('<div>').addClass('form-inline').append(
          $('<div>').addClass('form-group').append(
            $('<input>').attr('style', 'max-width:120px').attr('name', 'product[options_attributes][' + pp_index + '][suboptions_attributes][' + index + '][name]').addClass('form-control dynamical-required').attr('required', 'true').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{placeholder}')
          ),
          ' ',
          $('<div>').addClass('btn-group pull-right').append(
            $('<a>').addClass('fa fa-times-circle btn').click(#{gen_remove_option_panel})
          )
        ).fadeIn()
      );

      return false;
    }
  end

  def gen_add_option_to_new_variant(placeholder)
    %Q{
      function() {
        var pp_index = $(this).closest('.col-md-4').prevAll('.col-md-4').length;
        var body = $(this).closest('.panel').children('.panel-body');
        var index = body.find('input').length;

        body.append(
          $('<div>').addClass('form-inline').append(
            $('<div>').addClass('form-group').append(
              $('<input>').attr('style', 'max-width:120px').attr('name', 'product[options_attributes]['+pp_index+'][suboptions_attributes][' + index + '][name]').addClass('form-control dynamical-required input-sm').attr('required', 'true').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{placeholder}')
            ),
            ' ',
            $('<div>').addClass('btn-group pull-right').append(
              $('<a>').addClass('fa fa-times-circle btn').click(#{gen_remove_option_panel})
            )
          ).fadeIn()
        );

        return false;
      }
    }
  end

  def gen_add_variant_panel(variant_placeholder, option_placeholder)
    %Q{
      var body = $(this).closest('.panel').children('.panel-body').children('.form-group').children('.row')
      var index = body.find('.panel').length
      if (index < #{Rails.configuration.max_num_variants}) {
        body.append(
          $('<div>').addClass('col-md-4').append(
            $('<div>').addClass('panel panel-info').append(
              $('<div>').addClass('panel-heading').append(
                $('<div>').addClass('form-inline').append(
                  $('<div>').addClass('form-group').append(
                    $('<input>').attr('name', 'product[options_attributes]['+index+'][name]').attr('required', true).attr('style', 'max-width:120px').addClass('form-control input-sm dynamical-required').attr('required', 'true').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{variant_placeholder}')
                  ),
                  ' ',
                  $('<div>').addClass('btn-group pull-right').append(
                    $('<a>').addClass('fa fa-times-circle btn').click(#{gen_remove_variant_panel}),
                    $('<a>').addClass('fa fa-plus btn').click(#{gen_add_option_to_new_variant(option_placeholder)})
                  )
                )
              ),
              $('<div>').addClass('panel-body').append(
                $('<div>').addClass('form-inline').append(
                  $('<div>').addClass('form-group').append(
                    $('<input>').attr('style', 'max-width:120px').attr('name', 'product[options_attributes]['+index+'][suboptions_attributes][' + 0 + '][name]').addClass('form-control dynamical-required input-sm').attr('required', 'true').attr('maxLength', '#{Rails.configuration.max_tiny_text_length}').attr('placeholder', '#{option_placeholder}')
                  ),
                  ' ',
                  $('<div>').addClass('btn-group pull-right').append(
                    $('<a>').addClass('fa fa-times-circle btn').click(#{gen_remove_option_panel})
                  )
                )
              )
            )
          ).fadeIn()
        );
      }

      return false;
    }
  end

  def gen_upload_image

  end

  def enough_inventory(sku, quantity)
    return sku && (sku.unlimited or sku.quantity >= quantity )
  end

  def get_options_for_select(product)
    skus = product.skus.is_active.in_stock
    values = skus.map { |s| s.option_ids.compact.join(',') }
    names  = skus.map do |s|
      s.option_ids.compact.map do |oid|
        o = product.options.detect { |v| v.suboptions.where(id: oid).first }.suboptions.find(oid)
        o.name
      end.join(', ')
    end
    values.each_with_index.map { |v,i| [names[i], v] }
  end

  def get_options_json(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.where(id: oid).first
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      { name: v.name, option: { id: o.id, name: o.name } }
    end
  end

end
