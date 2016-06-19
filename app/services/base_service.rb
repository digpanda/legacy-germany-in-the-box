class BaseService


  def error!(error)
    setup.new(true, false, error)
  end

  def success!
    setup.new(false, true)
  end

  private

  def setup
    Struct.new(:is_error?, :is_success?, :error, :message)
  end
  
end