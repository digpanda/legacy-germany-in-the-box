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
    "#{full_address} <br /> #{country}"
  end

  # NOTE : street number aren't used anymore, it's one block in the system.
  # def full_address
  #   "#{province}#{city}#{district}#{street}#{number}#{additional}, #{zip}, #{country}"
  # end

end
