module ApplicationHelper
  include Mobvious::Rails::Helper

  def setting
    @setting ||= Setting.instance
  end

  # NOTE : I tried to refactor this part of the system
  # it's still extremely dirty and should be completely redone into a library.
  def get_provinces
    ChinaCity.list
  end

  def get_cities_for_province(province)
    ChinaCity.list get_code_for_province(province)
  end

  def get_districts_for_city(province, city)
    codes = get_cities_for_province(province)
    ChinaCity.list code_reducer(codes, city)
  end

  def get_code_for_province(province)
    code_reducer(get_provinces, province)
  end

  def get_code_for_city(province, city)
    codes = ChinaCity.list get_code_for_province(province)
    code_reducer(codes, city)
  end

  def get_code_for_district(province, city, district)
    codes = ChinaCity.list get_code_for_city(province, city)
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
