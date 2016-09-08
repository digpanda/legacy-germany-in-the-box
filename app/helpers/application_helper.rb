module ApplicationHelper
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

  def inside_layout(parent_layout='application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

end
