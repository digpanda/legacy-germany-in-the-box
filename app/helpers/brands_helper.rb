module BrandsHelper
  def referrer_rate_range(brand)
    rates = brand.package_sets.map(&:referrer_rate).sort.reject { |u| u == 0.0 }
    return '-' if rates.size == 0
    return "#{rates.first}%" if rates.size == 1
    "#{rates.first}% - #{rates.last}%"
  end
end
