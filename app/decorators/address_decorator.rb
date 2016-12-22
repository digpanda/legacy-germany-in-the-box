class AddressDecorator < Draper::Decorator

  delegate_all
  decorates :address

  def readable_type
    case type
    when :both
      "Shipping & Billing"
    when :billing
      "Billing"
    when :shipping
      "Shipping"
    else
      "Unknown"
    end
  end

  def street_and_number
    case country_code
    when 'CN' # originally zh-CN
      "#{number} #{street}"
    else
      "#{street} #{number}"
    end
  end

  def chinese_street_number
    "#{number}" # 号
  end

  def chinese_full_name
    "#{lname}#{fname}"
  end

  def imprint_address
    "#{street} #{number} <br /> #{zip} #{city} <br /> #{country}"
  end

  # NOTE : street number aren't used anymore, it's one block in the system.
  def full_address
    "#{province}#{city}#{district}#{street}#{number}#{additional}, #{zip}, #{country}"
  end

  def german_full_address
    "#{street} #{number}, #{zip} #{city}, #{country}"
  end

  def country_code
    country.alpha2 unless country.nil?
  end

  def country_name
    country.name unless country.nil?
  end

  def country_local_name
    country.local_name unless country.nil?
  end

end
