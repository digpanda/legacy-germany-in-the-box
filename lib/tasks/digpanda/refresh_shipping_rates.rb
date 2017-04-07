require 'csv'

class Tasks::Digpanda::RefreshShippingRates

  XIPOST_SHIPPING_PRICE_FILE = 'shipping-prices-xipost.csv'
  BEIHAI_SHIPPING_PRICE_FILE = 'shipping-prices-beihai.csv'
  IGNORED_LINES = ["列1", "西邮寄筋斗云精品快线钻石VIP价格表 （500-799单）", "Weight (KG)", ""]

  def initialize

    puts "We are running on `#{Rails.env}` environment"
    puts "We clear the file cache"
    Rails.cache.clear

    puts "We remove all old shipping rates"
    ShippingRate.delete_all

    process!(:xipost)
    process!(:beihai)

    puts "End of process."

  end

  def process!(partner)
    csv_fetch(partner) do |column|

      next if IGNORED_LINES.include? column[0]

      weight = column[0]
      if weight.empty?
        puts "There we a problem trying to recover `weight`"
        return
      end

      weight = weight.gsub(/[^0-9]/, '').to_f / 100

      price = column[1]
      if price.empty?
        puts "There we a problem trying to recover `price`"
        return
      end

      price = price.gsub(/[^0-9]/, '').to_f / 100

      shipping_rate = ShippingRate.create({
        :weight => weight,
        :price => price,
        :partner => partner
        })

      puts "[#{partner}] ShippingRate #{shipping_rate.weight} refresh with price `#{shipping_rate.price}`"

    end
  end

  def csv_fetch(partner)
    CSV.foreach(csv_file(partner), quote_char: '"', col_sep: ';', row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def csv_file(partner)
    if partner == :xipost
      File.join(Rails.root, 'vendor', XIPOST_SHIPPING_PRICE_FILE)
    elsif partner == :beihai
      File.join(Rails.root, 'vendor', BEIHAI_SHIPPING_PRICE_FILE)
    else
      raise Exception, "Logistic partner not recognized for Shipping Rates"
    end
  end

end
