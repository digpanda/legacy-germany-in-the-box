module ApplicationHelper
  include AppCache
  include Mobvious::Rails::Helper

  def get_provinces
    ChinaCity.list
  end

  def get_cities_for_province(province)
    ChinaCity.list(get_provinces().select { |p| p[0] == province }[0][1])
  end

  def get_districts_for_city(province, city)
    ChinaCity.list(get_cities_for_province(province).select { |p| p[0] == city }[0][1])
  end

  def get_code_for_province(province)
    ChinaCity.list.select { |p| p[0] == province }[0][1]
  end

  def get_code_for_city(province, city)
    ChinaCity.list(get_code_for_province(province)).select { |p| p[0] == city }[0][1]
  end

  def get_code_for_district(province, city, district)
    ChinaCity.list(get_code_for_city(province,city)).select { |p| p[0] == district }[0][1]
  end

  def generate_validate_pdf_file_js
    %Q{
      function validatePdfFile(inputFile) {
        var maxExceededMessage = "#{I18n.t(:max_exceeded_message, scope: :pdf_upload)}";
        var extErrorMessage = "#{I18n.t(:ext_error_message, scope: :pdf_upload)}";;
        var allowedExtension = ["pdf"];

        var extName;
        var maxFileSize = 2097152;
        var sizeExceeded = false;
        var extError = false;

        $.each(inputFile.files, function() {
          if (this.size && maxFileSize && this.size > maxFileSize) {sizeExceeded=true;};
          extName = this.name.split('.').pop();
          if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
        });
        if (sizeExceeded) {
          window.alert(maxExceededMessage);
          $(inputFile).val('');
        };

        if (extError) {
          window.alert(extErrorMessage);
          $(inputFile).val('');
        };
      }
    }
  end

  def inside_layout(parent_layout='application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

end
