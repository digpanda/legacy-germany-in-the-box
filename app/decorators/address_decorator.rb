class AddressDecorator < Draper::Decorator
  delegate_all
  decorates :address

  def readable_type
    case type
    when :both
      'Shipping & Billing'
    when :billing
      'Billing'
    when :shipping
      'Shipping'
    else
      'Unknown'
    end
  end

  def full_name
    if "#{fname}#{lname}".chinese?
      "#{lname}#{fname}"
    else
      "#{fname} #{lname}"
    end
  end

  def imprint_address
    "#{full_address} <br /> #{readable_country}"
  end

  def readable_country
    I18n.t("country.#{country}")
  end

end
