module ShopsHelper

  def gen_remove_sales_channel
    %Q{
      if ( $(this).closest('.form-group').siblings().length > 0 ) $(this).closest('.form-group').remove();
      return false;
    }
  end

  def gen_add_sales_channel(class_name)
    %Q{
      var body = $(this).closest('.panel').children('.panel-body');
      if (body.children().length < #{Rails.configuration.max_num_sales_channels}) {
        body.append(
          $('<div>').addClass('form-group').append(
            $('<div>').addClass('row').append(
              #{gen_sales_channel_select_tag(class_name)},
              $('<div>').addClass('col-md-6').append(
                $('<input>').attr('name', '#{class_name}[sales_channels][]').attr('required', true).attr('placeholder', '#{I18n.t(:sales_channel, scope: :index_shopkeeper)}').addClass('form-control dynamical-required').attr('maxLength', #{Rails.configuration.max_short_text_length})
              ),
              $('<div>').addClass('col-md-2').append(
                $('<a>').attr('href', '#').addClass('btn').append(
                  $('<i>').addClass('fa').addClass('fa-times-circle'),
                  ' #{I18n.t(:remove_sales_channel, scope: :index_shopkeeper)}'
                ).click(function () {
                  #{gen_remove_sales_channel}
                })
              )
            )
          ).fadeIn()
        );
      }

      return false;
    }
  end

  def gen_sales_channel_select_tag(class_name)
    %Q{
      $('<div>').addClass('col-md-4').append(
        $('<select>').attr('name', '#{class_name}[sales_channels][]').addClass('form-control').append(
          #{SalesChannelOptions::OPTIONS.map { |o| "$('<option>').val('#{o}').text('#{I18n.t(o, scope: 'edit_shop.sales_channel_options')}')" }.join(',')}
        )
      )
    }
  end

end
