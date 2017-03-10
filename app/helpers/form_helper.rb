module FormHelper

  def logistic_partners
    [['Border Guru', :borderguru],['Manual', :manual]]
  end

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

  def solve_index
    @solve_index = 0 unless @solve_index
    @solve_index += 1
  end

end
