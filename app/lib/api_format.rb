module ApiFormat

  module_function

  def success(label='data', data=[])
    { :status => :ok, label => data.as_json.reject(&:empty?) }
  end

  def fail(message)
    { :status => :ko, :error => message}
  end

end