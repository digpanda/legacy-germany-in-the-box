module UsersHelper

  def generate_set_datepicker_lang_js
    %Q{
      $( document ).ready( function () {
        $('.date-picker').datepicker({ language: '#{params[:locale] ?  params[:locale] : Rails.configuration.default_locale }', autoclose: true, todayHighlight: true })
      })
    }
  end

end
