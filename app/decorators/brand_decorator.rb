class BrandDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :brand

  def referrer_rate_range(user)
    rates = self.object.package_sets_referrer_rates_range(user)
    return '-' if rates.size == 0
    return "#{rates.first}%" if rates.size == 1
    "#{rates.first}% - #{rates.last}%"
  end
end
