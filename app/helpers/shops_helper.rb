module ShopsHelper

  def gen_add_target_group
    %Q{
      var body = $('#table_shop_target_groups_#{@shop.id}').find('tbody')
      if (body.children().length < #{Rails.configuration.max_num_target_groups}) {
        body.append(
          $('<tr>').addClass('form-group').append(
            $('<td>').attr('width', '80%').append(
              $('<input>').attr('name', 'shop[target_groups][]').attr('required', true).attr('placeholder', '#{I18n.t(:target_group, scope: :edit_shop)}').addClass('form-control dynamical-required').attr('maxLength', #{Rails.configuration.max_short_text_length})
            ),
            $('<td>').attr('width', '20%').append(
              $('<a>').attr('href', '#').addClass('btn').append(
                $('<i>').addClass('fa').addClass('fa-times-circle'),
                ' #{I18n.t(:remove_target_group, scope: :edit_shop)}'
              ).click(function () {
                $(this).closest('tr').remove(); return false;
              })
            )
          )
        );
      }

      return false;
    }
  end

  def gen_remove_sales_channel
    %Q{
      if ( $(this).closest('tr').siblings().length > 0 ) $(this).closest('tr').remove();
      return false;
    }
  end

  def gen_add_sales_channel(class_name)
    %Q{
      var body = $(this).closest('.panel').children('.panel-body').find('tbody');
      if (body.children().length < #{Rails.configuration.max_num_sales_channels}) {
        body.append(
          $('<tr>').append(
            #{gen_sales_channel_select_tag(class_name)},
            $('<td>').addClass('form-group').attr('width', '55%').append(
              $('<input>').attr('name', '#{class_name}[sales_channels][]').attr('required', true).attr('placeholder', '#{I18n.t(:sales_channel, scope: :edit_shop)}').addClass('form-control dynamical-required').attr('maxLength', #{Rails.configuration.max_short_text_length})
            ),
            $('<td>').attr('width', '15%').append(
              $('<a>').attr('href', '#').addClass('btn').append(
                $('<i>').addClass('fa').addClass('fa-times-circle'),
                ' #{I18n.t(:remove_sales_channel, scope: :edit_shop)}'
              ).click(function () {
                #{gen_remove_sales_channel}
              })
            )
          )
        );
      }

      return false;
    }
  end

  def gen_sales_channel_select_tag(class_name)
    %Q{
      $('<td>').attr('width', '30%').append(
        $('<select>').attr('name', '#{class_name}[sales_channels][]').addClass('form-control').append(
          $('<option>').val('Online-Shop').text('Online-Shop'),
          $('<option>').val('Online-Marktplatz').text('Online-Marktplatz'),
          $('<option>').val('Einzelhandler').text('Einzelhandler'),
          $('<option>').val('Workshop').text('Workshop')
        )
      )
    }
  end

end
