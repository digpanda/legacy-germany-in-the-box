module FormHelper

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

end
