class AddressDecorator < Draper::Decorator

  delegate_all

  def street_and_number
    if country_code == 'zh-CN'
      "#{number} #{street}"
    elsif country_code == 'DE'
      "#{street} #{number}"
    end
  end

end
