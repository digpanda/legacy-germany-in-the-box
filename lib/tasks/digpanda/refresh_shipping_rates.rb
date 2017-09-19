require 'csv'

class Tasks::Digpanda::RefreshShippingRates
  BEIHAI_SHIPPING_PRICE_FILE = 'shipping-prices-beihai.csv'.freeze
  MKPOST_SHIPPING_PRICE_FILE = 'shipping-prices-mkpost.csv'.freeze

  IGNORED_LINES = ['列1', '西邮寄筋斗云精品快线钻石VIP价格表 （500-799单）', 'Weight (KG)', '', 'MKPost'].freeze

  def initialize
    puts "We are running on `#{Rails.env}` environment"
    puts 'We clear the file cache'
    Rails.cache.clear

    puts 'We remove all old shipping rates'
    ShippingRate.delete_all

    process!(:beihai)
    process!(:mkpost)

    puts 'End of process.'
  end

  def process!(partner)
    puts "Processing `#{partner}` ... "

    csv_fetch(partner) do |column|

      # binding.pry if partner == :mkpost

      next if IGNORED_LINES.include? column[0]

      weight = column[0]
      if weight.empty?
        puts 'There we a problem trying to recover `weight`'
        return
      end

      weight = weight.gsub(',', '.').to_f

      price = column[1]
      if price.empty?
        puts 'There we a problem trying to recover `price`'
        return
      end

      price = price.gsub(',', '.').to_f

      shipping_rate = ShippingRate.create(
        weight: weight,
        price: price,
        partner: partner
        )

      puts "[#{partner}] ShippingRate #{shipping_rate.weight} refresh with price `#{shipping_rate.price}`"

    end

    puts "End of process for `#{partner}`."
  end

  def csv_fetch(partner)
    CSV.foreach(csv_file(partner), quote_char: '"', col_sep: col_sep(partner), row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def col_sep(partner)
    if partner == :mkpost
      ','
    else
      ';'
    end
  end

  def csv_file(partner)
    if partner == :beihai
      File.join(Rails.root, 'vendor', BEIHAI_SHIPPING_PRICE_FILE)
    elsif partner == :mkpost
      File.join(Rails.root, 'vendor', MKPOST_SHIPPING_PRICE_FILE)
    else
      raise Exception, 'Logistic partner not recognized for Shipping Rates'
    end
  end
end
