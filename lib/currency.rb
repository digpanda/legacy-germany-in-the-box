# small library to manage better the currencies by Laurent
# it's not worth what's around but it matches perfectly our current system
class Currency

  attr_reader :amount, :currency

  def initialize(amount, currency='EUR')
    if amount.nil?
      @amount = 0
    else
      @amount = amount
    end
    @currency = currency
  end

  def to_yuan
    update_currency!('CNY', amount * Setting.instance.exchange_rate_to_yuan)
  end

  def to_euro
    update_currency!('EUR', amount / Setting.instance.exchange_rate_to_yuan)
  end

  def display
    "#{current_symbol} %.2f" % amount
  end

  def display_raw
    "%.2f" % amount
  end

  def display_html
    "<span class=\"current_symbol\">#{current_symbol}</span> <span class=\"amount\">%.2f</span>" % amount
  end

  private

  def current_symbol
    if currency == 'EUR'
      Setting.instance.supplier_currency.symbol
    elsif currency == 'CNY'
      Setting.instance.platform_currency.symbol
    end
  end

  def update_currency!(new_currency, new_amount)
    unless new_currency == currency
      @currency = new_currency
      @amount = new_amount
    end
    self
  end

end
