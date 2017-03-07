require 'csv'

class Tasks::Digpanda::RefreshShippingRates

  GENERAL_SHIPPING_PRICE_FILE = 'shipping-prices-general.csv'
  IGNORED_LINES = ["列1", "西邮寄筋斗云精品快线钻石VIP价格表 （500-799单）", "Weight (KG)", ""]

  def initialize

    puts "We are running on `#{Rails.env}` environment"
    puts "We clear the file cache"
    Rails.cache.clear

    puts "We remove all old shipping rates"
    ShippingRate.delete_all

    csv_fetch do |column|

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
        :price => price
        })

      puts "ShippingRate #{shipping_rate.weight} refresh with price `#{shipping_rate.price}`"

    end

    puts "End of process."

  end

  def csv_fetch
    CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def csv_file
    @csv_file ||= File.join(Rails.root, 'vendor', GENERAL_SHIPPING_PRICE_FILE)
  end

end
