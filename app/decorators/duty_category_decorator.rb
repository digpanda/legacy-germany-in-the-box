class DutyCategoryDecorator < Draper::Decorator
  delegate_all
  decorates :duty_category

  def name_translations
    object.name_translations.collect { |k, v| [k.to_sym, "#{v} (#{object.code})"] }.to_h
  end
end
