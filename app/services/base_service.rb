class BaseService

  def setup
    Struct.new(:is_error?, :is_success?, :message)
  end

  def error!(message)
    setup.new(true, false, message)
  end

  def success!
    setup.new(false, true)
  end

end