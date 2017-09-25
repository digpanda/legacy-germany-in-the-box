class OrderPaymentDecorator < Draper::Decorator
  delegate_all
  decorates :address

  def amount_cny_with_currency
    Currency.new(amount_cny, 'CNY').display
  end

  def amount_eur_with_currency
    Currency.new(amount_eur, 'EUR').display
  end
end
