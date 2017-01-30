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
    code_reducer(get_provinces, province)
  end

  def get_code_for_city(province, city)
    codes = ChinaCity.list(get_code_for_province(province))
    code_reducer(codes, city)
  end

  def get_code_for_district(province, city, district)
    codes = ChinaCity.list(get_code_for_city(province, city))
    code_reducer(codes, district)
  end

  def code_reducer(codes, comparison)
    codes.reduce([]) do |acc, code|
      if code.first == comparison
        return code.last
      end
    end
  end

  def inside_layout(parent_layout='application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

end
