module FormHelper

  def logistic_partners
    [['Border Guru', :borderguru],['Manual', :manual]]
  end

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

end
