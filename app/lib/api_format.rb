module ApiFormat

  module_function

  def success(label, data)
    { :status => :ok, label => data.as_json.reject(&:empty?) }
  end

  #def error
  #  { :status => :ko} # i don't know how to format all that yet
  #end

end