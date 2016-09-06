class AddressDecorator < Draper::Decorator

  delegate_all
  decorates :address

  def street_and_number
    if country_code == 'zh-CN'
      "#{number} #{street}"
    elsif country_code == 'DE'
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
    "#{province}#{city}#{district}#{street}#{number}#{zip}, #{country}"
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
