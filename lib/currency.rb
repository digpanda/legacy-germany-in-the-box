# small library to manage better the currencies by Laurent
# it's not worth what's around but it matches perfectly our current system
class Currency

  attr_reader :amount, :currency

  def initialize(amount, currency='EUR')
    @amount = amount.to_i
    @currency = currency
  end

  def to_yuan
    update_currency!('CNY', amount * Settings.instance.exchange_rate_to_yuan)
  end

  def to_euro
    update_currency!('EUR', amount / Settings.instance.exchange_rate_to_yuan)
  end

  def display
    "%.2f #{current_symbol}" % amount
  end

  private

  def current_symbol
    if currency == 'EUR'
      symbol = Settings.instance.supplier_currency.symbol
    elsif currency == 'CNY'
      symbol = Settings.instance.platform_currency.symbol
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
