module ChinaCityHelper

  FEATURED_PROVINCES = %w(北京市 上海市 天津市 重庆市)

  def china_city_ordered_list
    ChinaCity.list.sort_by { |e| [ FEATURED_PROVINCES.index(e.first) || FEATURED_PROVINCES.size, e.first ] }
  end

end