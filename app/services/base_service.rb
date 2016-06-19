class BaseService

  def error(message)
    {
      :error => message,
      :success => false
    }
  end

  def success
    {
      :success => true
    }
  end

end