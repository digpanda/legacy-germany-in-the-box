class BaseService

  Response = Struct.new(:success?, :data, :error)
  Error = Class.new(StandardError)

  def return_with(state, details=nil)
    case state
    when :error
      Response.new(false, nil, details)
    when :success
      Response.new(true, details)
    else throw "Bad state."
    end
  end

end
